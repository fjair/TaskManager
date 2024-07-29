using Blazorise;
using Blazorise.DataGrid;
using Blazorise.Extensions;
using Blazorise.Snackbar;
using Microsoft.AspNetCore.Components;
using TaskManger.Components.Shared;
using TaskManger.Models;
using TaskManger.Services;


namespace TaskManger.Pages;

public partial class IndexTasks
{
    [Inject] IAppService AppService { get; set; }
    [Inject] MessageService MessageService { get; set; }
        
    IList<GoalModel> selectedGoals = new List<GoalModel>();
    List<GoalModel> GoalsList = new();

    bool Loading;

    protected override async Task OnInitializedAsync()
    {
        Loading = true;
        await LoadGoals();         
        Loading = false;
    }

    async Task LoadGoals()
    {
        var result = await AppService.GetAllGoals();
        if (result.IsSuccess)
        {
            GoalsList = result.Data ?? new();
            if (GoalsList.Count > 0) 
                selectedGoals.Add(GoalsList.FirstOrDefault());
        }
        else
            ErrorMessage(result.Message);

        StateHasChanged();
    }
    
    //async Task LoadTaasks()
    //{
    //    var result = await AppService.GetAllTaasks();
    //    if (result.IsSuccess)
    //        TaasksList = result.Data ?? new();
    //    else
    //        ErrorMessage(result.Message);
    //}    


    void SuccessMessage()
    {
        MessageService.ShowNotification($"Registro Guardado", Enums.NotificationEnum.Success);
    }
    
    void InfoMessage()
    {
        MessageService.ShowNotification($"Registro Actualizado", Enums.NotificationEnum.Info);
    }
    
    void WarningMessage(string message)
    {
        MessageService.ShowNotification($"{message}", Enums.NotificationEnum.Warning);
    }
    
    void DeleteMessage()
    {
        MessageService.ShowNotification($"Registro Eliminado", Enums.NotificationEnum.Warning);
    }
    
    void ErrorMessage(string message)
    {
        MessageService.ShowNotification($"Ocurrio un Error: {message}", Enums.NotificationEnum.Error);
    }


    #region FOR GOALS
    GoalModel GoalModelRef = new();          
    Modal ModalGoalRef;
    DeleteModal DeleteModalRef;
    Validations ValidationsRef;

    
    Task AddGoalModal()
    {
        GoalModelRef = new();
        return ModalGoalRef.Show();
    }
    
    async Task UpdateGoalModal(GoalModel model)
    {
        GoalModelRef = (await AppService.GetGoalByID(model.ID)).Data;
        await ModalGoalRef.Show();
    }
    
    async Task SaveGoal()
    {
        if (await ValidationsRef.ValidateAll())
        {
            if (!GoalsList.Any(x => x.Name == GoalModelRef.Name))
            {
                if (GoalModelRef.ID == 0)
                {
                    var resultAdd = await AppService.AddGoal(GoalModelRef);
                    if (resultAdd.IsSuccess)
                        SuccessMessage();
                    else
                        ErrorMessage(resultAdd.Message);
                }
                else
                {
                    var resultUpdate = await AppService.UpdateGoal(GoalModelRef);
                    if (resultUpdate.IsSuccess)
                        InfoMessage();
                    else
                        ErrorMessage(resultUpdate.Message);
                }

                StateHasChanged();
                await LoadGoals();
                await ModalGoalRef.Hide();
            }
            else
                WarningMessage("Ya existe esta Meta!");            
        }
    }

    Task DeleteGoalModal(GoalModel model)
    {
        GoalModelRef = model;        
        return DeleteModalRef.Open();
    }

    async Task OnDeleteGoal(GoalModel model)
    {
        var resultDelete = await AppService.DeleteGoal(model);
        if (resultDelete.IsSuccess)        
            DeleteMessage();                               
        else
            ErrorMessage(resultDelete.Message);
        
        StateHasChanged();
        await LoadGoals();
        selectedGoals = GoalsList.Take(1).ToList();
        await DeleteModalRef.Close();        
    }

    #endregion


    #region FOR TAASKS
    TaaskModel TaaskModelRef = new();    
    List<TaaskModel> TaasksList = new();
    IList<TaaskModel> selectedTaasks = new List<TaaskModel>();
    Modal ModalTaaskRef;
    DeleteModal DeleteModalRef2;
    Validations ValidationsRef2;

    Task AddTaaskModal()
    {
        TaaskModelRef = new();        
        TaaskModelRef.LineNum = SetLineNum();        
        return ModalTaaskRef.Show();
    }

    Task UpdateTaaskModal()
    {
        TaaskModelRef = selectedTaasks.FirstOrDefault();
        return ModalTaaskRef.Show();
    }

    int SetLineNum()
    {
        if (selectedGoals.FirstOrDefault().TasksList.Count == 0)
            return 1;

        return selectedGoals.FirstOrDefault().TasksList.Max(x => x.LineNum) + 1;
    }

    async Task SaveTaask()
    {
        if (await ValidationsRef2.ValidateAll())
        {
            if (!TaasksList.Any(X => X.Name == TaaskModelRef.Name))
            {
                TaaskModelRef.GoalID = selectedGoals.FirstOrDefault().ID;

                var result = TaaskModelRef.ID == 0
                    ? await AppService.AddTaask(TaaskModelRef)
                    : await AppService.UpdateTaask(TaaskModelRef);

                if (result.IsSuccess)
                {
                    if (!selectedGoals.FirstOrDefault().TasksList.Any(x => x.LineNum == TaaskModelRef.LineNum))
                        selectedGoals.FirstOrDefault().TasksList.Add(TaaskModelRef);

                    if (TaaskModelRef.ID == 0)
                        SuccessMessage();
                    else
                        InfoMessage();
                }
                else                
                    ErrorMessage(result.Message);                
                
                StateHasChanged();                            
                await ModalTaaskRef.Hide();
            }
            else
                WarningMessage("Ya existe esta Tarea!");
        }
    }


    async Task OnCompleteTask(bool isCompleted)
    {
        TaaskModelRef = selectedTaasks.FirstOrDefault();
        TaaskModelRef.IsCompleted = isCompleted;

        var resultUpdate = await AppService.UpdateTaask(TaaskModelRef);
        if (resultUpdate.IsSuccess)
        {
            if (!selectedGoals.FirstOrDefault().TasksList.Any(x => x.LineNum == TaaskModelRef.LineNum))
                selectedGoals.FirstOrDefault().TasksList.Add(TaaskModelRef);

            InfoMessage();
        }
        else
            ErrorMessage(resultUpdate.Message);

        StateHasChanged();
    }
    
    async Task OnMarkAsFavorite(TaaskModel model , bool isFavorite)
    {
        model.IsFavorite = isFavorite;

        var resultUpdate = await AppService.UpdateTaask(model);
        if (resultUpdate.IsSuccess)
        {
            //if (!selectedGoals.FirstOrDefault().TasksList.Any(x => x.LineNum == TaaskModelRef.LineNum))
            //    selectedGoals.FirstOrDefault().TasksList.Add(model);

            InfoMessage();
        }
        else
            ErrorMessage(resultUpdate.Message);

        StateHasChanged();
    }

    Task DeleteTaaskModal()
    {
        TaaskModelRef = selectedTaasks.FirstOrDefault();
        return DeleteModalRef2.Open();
    }

    async Task OnDeleteTaaskl()
    {        
        var resultDelete = await AppService.DeleteTaask(TaaskModelRef);
        if (resultDelete.IsSuccess)
        {
            selectedGoals.FirstOrDefault().TasksList.Remove(TaaskModelRef);
            DeleteMessage();
        }
        else
            ErrorMessage(resultDelete.Message);

        StateHasChanged();
        await DeleteModalRef2.Close();        
    }

    #endregion
}

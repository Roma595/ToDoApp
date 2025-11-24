using System.Collections.ObjectModel;

namespace TODOLIST;

public partial class MainPage : ContentPage
{
    public ObservableCollection<TaskItem> Tasks { get; set; } = new ObservableCollection<TaskItem>();

    public MainPage()
    {
        InitializeComponent();
        TasksCollection.ItemsSource = Tasks;
        Tasks.Add(new TaskItem { Text = "Пример задачи 1" });
        Tasks.Add(new TaskItem { Text = "Пример задачи 2" });
    }

    private void OnAddTaskClicked(object sender, EventArgs e)
    {
        if (!string.IsNullOrWhiteSpace(NewTaskEntry.Text))
        {
            Tasks.Add(new TaskItem { Text = NewTaskEntry.Text });
            NewTaskEntry.Text = "";
        }
    }

    private void OnTaskCheckedChanged(object sender, CheckedChangedEventArgs e)
    {
    }

    private void OnDeleteTaskClicked(object sender, EventArgs e)
    {
        if (sender is Button button && button.BindingContext is TaskItem task)
        {
            Tasks.Remove(task);
        }
    }
}

public class TaskItem
{
    public string Text { get; set; }
    public bool IsCompleted { get; set; }
}
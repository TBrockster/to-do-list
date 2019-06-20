# this is the menu module
module Menu
  def menu
    puts "Welcome to your 'To Do' list!
  Please choose from the following:
    1) Add a Task
    2) Show all Tasks
    3) Update Task
    4) Delete a Task
    5) Write to File
    6) Read from File
    7) Toggle Status
    Q) Quit"
  end

  def show
    menu
  end
end

# this is the prompt module
module Promptable
  def prompt(message = 'What would you like to do?', symbol = ':> ')
    puts message
    print symbol
    gets.chomp
  end
end

# this is the list class
class List
  attr_reader :all_tasks
  def initialize
    @all_tasks = []
  end

  # adds task to @all_tasks array
  def add(task)
    @all_tasks << task
    puts "You have added '#{task.description}' to the 'To Do' list"
  end

  # deletes a task from @all_tasks array
  def delete_task(task_number)
    all_tasks.delete_at(task_number.to_i - 1)
    puts "Task ##{task_number} Deleted"
  end

  # updates a task in @all_tasks array
  def update_task(task_number, task)
    all_tasks[task_number.to_i - 1] = task
  end

  # puts all tasks in @all_tasks array, inlcuding number and status
  def show_tasks
    puts 'To Do:'
    all_tasks.each { |task| puts "#{all_tasks.index(task) + 1}) #{task.to_machine}" }
  end

  # writes the @all_tasks array to a new file
  def write_to_file(filename)
    machinified = @all_tasks.map(&:to_machine).join("\n")
    IO.write(filename, machinified)
  end

  # creates a list of tasks from a file
  def read_from_file(filename)
    IO.readlines(filename).each do |line|
      status, *description = line.split(':')
      status = status.include?('X')
      add(Task.new(description.join(':').strip, status))
    end
  end

  # toggles the status of a task
  def toggle(task_number)
    all_tasks[task_number.to_i - 1].toggle_status
  end
end

# this is the task class
class Task
  attr_reader :description
  attr_accessor :status
  def initialize(description, completed_status = false)
    @description = description
    @completed_status = completed_status
  end

  # allows the description to be called as a string
  def to_s
    description
  end

  # allows the status of the task to be called
  def completed?
    @completed_status
  end

  # allows the status of the task to be toggled
  def toggle_status
    @completed_status = !completed?
  end

  # allows the task to visually display status and description
  def to_machine
    "#{represent_status}: #{description}"
  end

  # ternary operator reporting if the status is completed
  private

  def represent_status
    "#{completed? ? '[X]' : '[ ]'}"
  end
end

if $PROGRAM_NAME == __FILE__ # program runner
  include Menu
  include Promptable
  my_todo_list = List.new
  until (user_input = prompt(show)).downcase.include?('q')
    case user_input
    when '1'
      my_todo_list.add(Task.new(prompt('Please enter task to add')))
    when '2'
      my_todo_list.show_tasks
    when '3'
      my_todo_list.show_tasks
      my_todo_list.update_task(prompt('Please enter task number to update'), Task.new(prompt('Please enter updated task')))
    when '4'
      my_todo_list.show_tasks
      my_todo_list.delete_task(prompt('Please enter the task number to delete'))
    when '5'
      my_todo_list.write_to_file(prompt('Please enter File Name'))
    when '6'
      begin
        my_todo_list.read_from_file(prompt('Please enter File Name'))
      rescue Errno::ENOENT
        puts 'File name not found, please verify your file name
        and path.'
      end
    when '7'
      my_todo_list.show_tasks
      my_todo_list.toggle(prompt('Please enter the number of the task you wish to toggle'))
      my_todo_list.show_tasks
    else
      puts 'Sorry, I did not understand'
    end
    prompt('

        Press enter to continue', '')
  end
  puts 'Goodbye, have a nice day!'
end

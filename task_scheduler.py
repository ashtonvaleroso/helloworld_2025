from datetime import datetime, timedelta
from typing import List, Tuple, Optional
# import heapq

# flexible, need to be scheduled, ex. homework
class Task:    
    def __init__(self, name: str, estimated_time: float, due_date: datetime,
                 start_date: datetime, priority: int):

        self.name = name
        self.estimated_time = estimated_time  # in hours
        self.due_date = due_date # datetime object
        self.start_date = start_date
        self.priority = priority #1, 2, or 3 -- 1 = highest

    # __lt__ method defines behavior of comparison operators
    def __lt__(self, other):
        # if tasks have different priorities, compare them
        if self.priority != other.priority:
            # lower number = higher priority
            return self.priority < other.priority
        # for tasks with same priority, return earlier due date 
        return self.due_date < other.due_date  

    # __repr__ = tostring method
    def __repr__(self):
        return f"Task('{self.name}', {self.estimated_time} hours, priority={self.priority})"

# fixed event, cannot be moved, ex. class
class Event:
    def __init__(self, name: str, location: str, time: datetime, duration: float):
        self.name = name
        self.location = location # implement location functionality later
        self.time = time
        self.duration = duration  # in hours

    def __repr__(self):
        return f"Event('{self.name}' at {self.location}, {self.time.strftime('%Y-%m-%d %H:%M')})"

class User:
    def __init__(self, name: str, email: str, working_hours: Tuple[int, int] = (9, 17)):
        self.name = name
        self.email = email
        # tuple of (start hour, end hour) -- default is (9,17) = 9am - 5pm
        self.working_hours = working_hours

# block of time that can contain a task, or multiple short tasks
class WorkBlock:
    def __init__(self, start_time: datetime, duration: float = 2.0):
        # by default, duration is 2 hours, can change
        self.start_time = start_time
        self.duration = duration
        self.end_time = start_time + timedelta(hours=duration)
        # list of tasks for this time block
        self.tasks = [] 
        # hours remaining -- use to check if a new task can be added
        self.remaining_time = duration 

    def add_task(self, task: Task) -> bool:
        # check if there is enough time for a task
        if task.estimated_time <= self.remaining_time:
            self.tasks.append(task)
            self.remaining_time -= task.estimated_time
            return True
        # not enough time to add task, return false
        return False

    def __repr__(self):
        task_names = [task.name for task in self.tasks]
        return f"WorkBlock({self.start_time.strftime('%Y-%m-%d %H:%M')}, tasks={task_names})"

# main scheduling class
class TaskScheduler:
    # organizes tasks into WorkBlocks and avoids fixed events
    def __init__(self, user: User):
        # implement user stuff later
        self.user = user
        # tasks that need to be scheduled
        self.tasks = []  
        # fixed events
        self.events = []
        # generated WorkBlocks, each with assigned tasks
        self.work_blocks = []

    # CHECK ABOUT THESE METHODS -- WHY DO I NEED THEM?
    def add_task(self, task: Task):
        self.tasks.append(task)

    def add_event(self, event: Event):
        self.events.append(event)

    def _is_time_blocked(self, start_time: datetime, end_time: datetime) -> bool:
        # check if time slot conflicts with an event

        for event in self.events:
            event_end = event.time + timedelta(hours=event.duration)
            # logic below is a little confusing -- but basically 
            # if the work block ends after the event starts AND the work block starts before the event ends --> they overlap
            if (end_time > event.time and start_time < event_end):
                return True
        # if the events don't overlap
        return False

    def _in_working_hours(self, time: datetime) -> bool:
        # check if a given time is between the working hours
        hour = time.hour
        if (self.user.working_hours[0] <= hour and hour < self.user.working_hours[1]):
            return True
        return False

    def _get_available_slots(self, start_date: datetime, end_date: datetime,
                            block_duration: float = 2.0) -> List[WorkBlock]:
        # return list of all WorkBlocks within the date range
        # these WorkBlocks avoid events and fall within working hours
        
        available_blocks = []
        # beginning of working hours on the start date
        current_date = start_date.replace(hour=self.user.working_hours[0], minute=0, second=0, microsecond=0)

        while current_date < end_date:
            if self._in_working_hours(current_date):
                block_end = current_date + timedelta(hours=block_duration)

                # check that the block doesn't go beyond working hours
                if block_end.hour <= self.user.working_hours[1]:
                    # adds WorkBlock unless it conflcits with an event
                    if not self._is_time_blocked(current_date, block_end):
                        available_blocks.append(WorkBlock(current_date, block_duration))
                
                # move current date forward to keep iterating
                current_date = block_end
            else:
            # if not in working hours, move to the next start of work hours
                if current_date.hour >= self.user.working_hours[1]:
                    # move to next day at start of work hours
                    current_date = (current_date + timedelta(days=1)).replace(
                        hour=self.user.working_hours[0], minute=0, second=0, microsecond=0
                    )
                else:
                    # it is too early currently --> go to start of working hours today
                    current_date = current_date.replace(
                        hour=self.user.working_hours[0], minute=0, second=0, microsecond=0
                    )

        return available_blocks

    # main scheduling algorithm -- assigns tasks to WorkBlocks
    def schedule_tasks(self, start_date: datetime = None, end_date: datetime = None) -> List[WorkBlock]:
        # steps: sort tasks by priority/due date, generate work blocks, try to fit tasks that fit in the timeframe
        
        # if no date range given, start date is today, end date is one week from today
        if not start_date:
            start_date = datetime.now()
        if not end_date:
            end_date = start_date + timedelta(days=7)

        # sort tasks by priority (primary key) and then due date (secondary key)
        sorted_tasks = sorted(self.tasks, key=lambda x: (x.priority, x.due_date))

        # gets all available blocks in range
        available_blocks = self._get_available_slots(start_date, end_date)

        scheduled_blocks = []
        unscheduled_tasks = []

        # loop through the available blocks
        for block in available_blocks:
            filled_tasks = []

            for task in sorted_tasks:
                # if task fits in time, add it
                if task.start_date <= block.start_time and task.due_date >= block.end_time:
                    # WorkBlock.add_task() returns True if task fits
                    if block.add_task(task): 
                        filled_tasks.append(task)

            # remove filled tasks from overall list
            for task in filled_tasks:
                sorted_tasks.remove(task)

            # get rid of blocks that have no tasks
            if block.tasks:
                scheduled_blocks.append(block)

        # remaining tasks that weren't able to be scheduled
        unscheduled_tasks = sorted_tasks

        # display unscheduled tasks
        if unscheduled_tasks:
            print(f"\nWarning: {len(unscheduled_tasks)} tasks could not be scheduled:")
            for task in unscheduled_tasks:
                print(f"  - {task.name} ({task.estimated_time}h, due: {task.due_date.strftime('%Y-%m-%d')})")

        return scheduled_blocks

    def print_schedule(self, blocks: List[WorkBlock], start_date: datetime, end_date: datetime):
        # print all work blocks and events chronologically to show complete daily schedule

        print(f"\n{'='*50}")
        print(f"Complete Schedule for {self.user.name}")
        print(f"{'='*50}\n")

        # combine work blocks and events into one list for chronological display
        schedule_items = []

        # add work blocks
        for block in blocks:
            schedule_items.append({
                'type': 'work_block',
                'start_time': block.start_time,
                'end_time': block.end_time,
                'data': block
            })

        # add events within the date range
        for event in self.events:
            if start_date <= event.time < end_date:
                event_end = event.time + timedelta(hours=event.duration)
                schedule_items.append({
                    'type': 'event',
                    'start_time': event.time,
                    'end_time': event_end,
                    'data': event
                })

        # sort by start time
        schedule_items.sort(key=lambda x: x['start_time'])

        current_date = None
        for item in schedule_items:
            item_date = item['start_time'].date()

            # print date header when we move to a new day
            if current_date != item_date:
                print(f"\n{item_date.strftime('%A, %B %d, %Y')}")
                print("-" * 30)
                current_date = item_date

            # print the schedule item
            start_str = item['start_time'].strftime('%H:%M')
            end_str = item['end_time'].strftime('%H:%M')

            if item['type'] == 'event':
                event = item['data']
                print(f"{start_str} - {end_str}: {event.name} @ {event.location} [CLASS]")
            else:  # work_block
                block = item['data']
                print(f"{start_str} - {end_str}: Work Block")
                for task in block.tasks:
                    print(f"  • {task.name} ({task.estimated_time}h)")

        print(f"\n{'='*50}\n")

# example -- my class schedule monday tuesday and wednesday
def main():
    # Create a user with working hours from 9 AM to 6 PM
    user = User("Rohan", "rohan@example.com", working_hours=(9, 18))
    scheduler = TaskScheduler(user)

    # fixed events

    # monday classes
    scheduler.add_event(Event(
        "CS 180",
        "WTHR",
        datetime(2025, 9, 22, 12, 30),  # sep 22, 12:30 PM
        duration=1.0  # 1 hour
    ))
    scheduler.add_event(Event(
        "MA 27101",
        "SCHM",
        datetime(2025, 9, 22, 13, 30),
        duration=1.0 
    ))
    scheduler.add_event(Event(
        "CS 193",
        "WALC 1055",
        datetime(2025, 9, 22, 18, 30),  
        duration=1.0 
    ))
    # tuesday classes
    scheduler.add_event(Event(
        "MA 27101",
        "SCHM",
        datetime(2025, 9, 23, 13, 30),
        duration=1.0 
    ))
    scheduler.add_event(Event(
        "EAPS 375",
        "ARMS",
        datetime(2025, 9, 23, 3, 0),  
        duration=1.25
    ))
    # wednesday classes
    scheduler.add_event(Event(
        "CS 180",
        "WTHR",
        datetime(2025, 9, 24, 12, 30),  # sep 22, 12:30 PM
        duration=1.0  # 1 hour
    ))
    scheduler.add_event(Event(
        "MA 27101",
        "SCHM",
        datetime(2025, 9, 24, 13, 30),
        duration=1.0 
    ))
    scheduler.add_event(Event(
        "CS 180 LAB",
        "DSAI",
        datetime(2025, 9, 23, 15, 30),  
        duration=2.0 
    ))
    # tasks
    scheduler.add_task(Task(
        "Math Homework",
        estimated_time=1.5,  # 1.5 hours
        due_date=datetime(2025, 9, 24),  # Due sep 24
        start_date=datetime(2025, 9, 21),  # Can start sep 21
        priority=1  # high priority
    ))
    scheduler.add_task(Task(
        "CS 193 homework",
        estimated_time=2.0,  # 2 hours (fills a whole work block)
        due_date=datetime(2025, 9, 23),
        start_date=datetime(2025, 9, 22),
        priority=2  # medium priority
    ))
    scheduler.add_task(Task(
        "EAPS written response",
        estimated_time=0.5,
        due_date=datetime(2025, 9, 23),
        start_date=datetime(2025, 9, 23),
        priority=3  # low priority
    ))
    # more sample tasks
    scheduler.add_task(Task(
        "Project Proposal",
        estimated_time=1.5,  # 1.5 hours
        due_date=datetime(2025, 9, 24),
        start_date=datetime(2025, 9, 20),
        priority=2  # Medium priority
    ))
    scheduler.add_task(Task(
        "Reading Assignment",
        estimated_time=0.5,  # 30 minutes (short task)
        due_date=datetime(2025, 9, 22),
        start_date=datetime(2025, 9, 20),
        priority=3  # Low priority
    ))

    # Schedule tasks from sep 22-24
    start = datetime(2025, 9, 22, 0, 0)
    end = datetime(2025, 9, 24, 0, 0)

    # Generate the schedule and print it
    scheduled_blocks = scheduler.schedule_tasks(start, end)
    scheduler.print_schedule(scheduled_blocks, start, end)

if __name__ == "__main__":
    main()
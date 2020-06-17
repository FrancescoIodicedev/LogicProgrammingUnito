#
INDEX_WEEK_IN_SLOT = 6
WEEK_SUBSET_CALENDAR = 6
WEEK_CALENDAR = 25

day_map = {'lun': 10,
            'mar': 20,
            'mer': 30,
            'gio': 40,
            'ven': 50,
            'sab': 60}

def load_file(path):
    with open(path, 'r') as file:
        lines = file.readlines()
    return lines[0].split(' ')


def get_days_by_week(f, week):
    days = []
    for line in f:
        if line.startswith('slot'):
            single_slot = line.split(',')
            curr_week = single_slot[6].replace(')','')
            if curr_week == week :
                days.append(line)
    return days


def format_calendar(f):
    calendar = [ [] for _ in range(25) ]
    support_info = []
    for line in f:
        if line.startswith('slot'):
            single_slot = line.split(',')
            week = single_slot[WEEK_SUBSET_CALENDAR].replace(')','')
            days_slot = sort_days_hours(get_days_by_week(f, week))
            if calendar[int(week)-1] != None:
                calendar[int(week)-1] = days_slot
        else :
            support_info.append(line)
    return calendar, support_info

def day_hour(hour_slot):
    slots = hour_slot.split(',')
    rank_d = day_map[slots[0].split('(')[1].split('_')[1]]
    rank_h = int(slots[1]) - 8
    #print('Slot : {}\nRank : {}'.format(hour_slot,rank_h + rank_d))
    return rank_h + rank_d

def sort_days_hours(list_hours_slot_for_a_week):
    return sorted(list_hours_slot_for_a_week, key=day_hour)


def print_day(day,write_on_file):
    slot_list = day.split(',')
    day = slot_list[0].split('_')[1].capitalize()
    print('{} \t {}:00 - {}:00 \t {} \n\t\t\t\t\t\t Docente: {}'
          .format(day, slot_list[1], slot_list[2], slot_list[3].replace('_', ' ').capitalize(), slot_list[4]))


def write_on_file(slot_list):
    f = open("result.txt", "w")
    for index,week in enumerate(calendar):
        f.write('Settima {}\n'.format(index+1))
        for day in week:
            slot_list = day.split(',')
            day = slot_list[0].split('_')[1].capitalize()
            f.write('{} \t {}:00 - {}:00 \t {} \n\t\t\t\t\t\t Docente: {}'
                        .format(day, slot_list[1], slot_list[2], slot_list[3].replace('_', ' ').capitalize(), slot_list[4]))
            f.write('\n\n')
        print('\n\n')

    f.close()


if __name__ == "__main__":
    #slot_list = load_file('answer_full_model.txt')
    slot_list = load_file('answer_full_model.txt')

    calendar, support_info = format_calendar(slot_list)

    for index,week in enumerate(calendar):
        print('Settima {}\n'.format(index+1))
        for day in week:
            print_day(day,0)
        print('\n\n')

    for line in support_info:
        print(line+'\n')

    write_on_file(slot_list)


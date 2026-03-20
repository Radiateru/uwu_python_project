my_list = [1, 3, -5, 100, 6]

def list_max(list):
    maximum = list[0]
    for i in list:
        if i > maximum:
            maximum = i
    return maximum

print(list_max(my_list))

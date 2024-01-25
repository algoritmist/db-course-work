def headers():
    return "ИД;НАЗВАНИЕ;РАСШИФРОВКА"


class DepartmentType:
    def __init__(self, id, name, description):
        self.id = id
        self.name = name
        self.description = description

    def __repr__(self):
        return f"{self.id};{self.name};{self.description}"


def generate():
    return [
        DepartmentType(0, "Отдел менеджмента", '''
                       Осуществляет обработку заявок от пользователей и проверяет обязательное условие
                        для выполнения заявки – продажа души Мефистофелю'''.replace("\n", " ")),
        DepartmentType(1, "Торговый отдел", '''
                       Этот отдел отвечает за поиск людей, которые продают предмет, указанный в заказе пользователя.
                       Компания выбирает предмет, который дешевле всего обойдется заказчику с учетом транспортировки. 
                       Если средств у пользователя достаточно, отправляются заявки в финансовый и транспортный отделы'''.replace(
            "\n", " ")),
        DepartmentType(2, "Отдел поиска людей", '''
                       Этот отдел отвечает за поиск людей, местоположение которых полностью не известно. 
                       Поиск может осуществляться как в стране проживания этого человека, если она известна, так и по всему миру.'''.replace(
            "\n", " ")),
        DepartmentType(3, "Финансовый отдел", '''
                       Списывает сумму с заказчика и предоставляет средства отделу, передавшему заявку.'''.replace("\n",
                                                                                                                   " ")),
        DepartmentType(5, "Военный отдел", '''
                       Отвечает за ведение войны с другими людьми.
                       Занимается наймом полководцев и войск, а также формирует свои отряды, состоящие из бесов.
                       Итоговое войско формируется таким образом, чтобы гарантированно одержать победу и потратить минимум средств.
                       Если у пользователя достаточно средств, то направляется заявка в транспортный отдел, для доставки войск в зону боевых действий.
                       Также направляется заявка в финансовый отдел'''.replace("\n", " "))
    ]

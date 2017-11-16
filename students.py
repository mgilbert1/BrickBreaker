class Student:
    def __init__(self, name, dorm):
        self.name = name
        self.dorm = dorm


def main():
    students = [
        Student("Stelios", "Branford"),
        Student("Maria", "Cabot"),
        Student("Anushree", "Ezra Stiles"),
        Student("Brian", "Winthrop")
    ]
    print("Before:")
    for student in students:
        print(f"{student.name} from {student.dorm}")
    students = sorted(students, key=lambda student: student.name)
    print("After:")
    for student in students:
        print(f"{student.name} from {student.dorm}")


if __name__ == "__main__":
    main()

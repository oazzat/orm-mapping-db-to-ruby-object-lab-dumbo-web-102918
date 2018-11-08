require "pry"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new()
    #binding.pry
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all_students_in_grade_9
    self.all.select{|student| student.grade == "9"}
  end

  def self.students_below_12th_grade
    self.all.select{|student| student.grade.to_i <= 11}
  end

  def self.first_X_students_in_grade_10(num)
    self.all.select{|student| student.grade.to_i == 10}[0...num]
  end

  def self.first_student_in_grade_10
    self.all.find{|student| student.grade.to_i == 10}
  end

  def self.all_students_in_grade_X(num)
    self.all.select{|student| student.grade.to_i == num}
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    all_students = DB[:conn].execute(sql)

    all_students.map {|row| Student.new_from_db(row)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    GROUP BY name
    SQL
    row = DB[:conn].execute(sql,name).flatten
    self.new_from_db(row)

    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

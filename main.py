from PyQt5 import QtWidgets
from PyQt5.QtGui import QIcon, QFontDatabase
import psycopg2
import os
import sqlparse

class ExhibitApp(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()

    def create_database(self):
        try:
            admin_conn = psycopg2.connect(
                user='postgres',
                password='1234',
                host='localhost',
                database='postgres'
            )
            admin_conn.autocommit = True
            admin_cursor = admin_conn.cursor()

            admin_cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'virtualexhibit';")
            if admin_cursor.fetchone():
                QtWidgets.QMessageBox.information(self, "Info", "Database 'virtualexhibit' already exists!")
                return

            admin_cursor.execute("CREATE DATABASE virtualexhibit OWNER exhibit_user;")
            QtWidgets.QMessageBox.information(self, "Success", "Database 'virtualexhibit' has been created!")

            admin_cursor.close()
            admin_conn.close()

            user_conn = psycopg2.connect(
                user='exhibit_user',
                password='1234',
                host='localhost',
                database='virtualexhibit'
            )
            user_cursor = user_conn.cursor()

            script_files = [
                "creation.sql",
                "indexes.sql",
                "procedures.sql",
                "triggers.sql"
            ]

            for script in script_files:
                file_path = os.path.join(os.getcwd(), script)
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        sql_script = f.read()

                    statements = sqlparse.split(sql_script)
                    for statement in statements:
                        if statement.strip():
                            user_cursor.execute(statement)
                    QtWidgets.QMessageBox.information(self, "Success", f"Executed {script} successfully.")
                except FileNotFoundError:
                    QtWidgets.QMessageBox.critical(self, "Error", f"Script '{script}' not found!")
                except Exception as e:
                    QtWidgets.QMessageBox.critical(self, "Error", f"Failed to execute '{script}': {str(e)}")

            user_conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", "Database structure has been set up successfully!")

        except Exception as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to create database: {str(e)}")
        finally:
            if 'user_cursor' in locals():
                user_cursor.close()
            if 'user_conn' in locals():
                user_conn.close()

    def delete_database(self):
        try:
            conn = psycopg2.connect(
                user='postgres',
                password='1234',
                host='localhost',
                database='postgres'
            )
            conn.autocommit = True
            cursor = conn.cursor()

            cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'virtualexhibit';")
            if cursor.fetchone():
                cursor.execute("DROP DATABASE virtualexhibit;")
                QtWidgets.QMessageBox.information(self, "Success", "Database 'virtualexhibit' has been deleted!")
            else:
                QtWidgets.QMessageBox.information(self, "Info", "Database 'virtualexhibit' does not exist.")
        except Exception as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to delete database: {str(e)}")
        finally:
            cursor.close()
            conn.close()

    def initUI(self):
        app.setWindowIcon(QIcon("icon.png"))
        self.setWindowTitle('Virtual Exhibit')
        self.setGeometry(100, 100, 1200, 800)
        font_id = QFontDatabase.addApplicationFont("ChakraPetch-Regular.ttf")
        font_family = QFontDatabase.applicationFontFamilies(font_id)[0]

        with open("style.qss", "r") as f:
                style = f.read()
                self.setStyleSheet(style.replace("custom-font", font_family))

        main_layout = QtWidgets.QVBoxLayout()
        top_button_layout = QtWidgets.QHBoxLayout()

        self.clear_db_button = QtWidgets.QPushButton("Clear Database")
        self.clear_db_button.clicked.connect(self.clear_database)

        self.clear_tab_button = QtWidgets.QPushButton("Clear Current Tab")
        self.clear_tab_button.clicked.connect(self.clear_current_tab)

        self.create_db_button = QtWidgets.QPushButton("Create Database")
        self.create_db_button.clicked.connect(self.create_database)

        self.delete_db_button = QtWidgets.QPushButton("Delete Database")
        self.delete_db_button.clicked.connect(self.delete_database)

        top_button_layout.addWidget(self.create_db_button)
        top_button_layout.addWidget(self.delete_db_button)
        top_button_layout.addWidget(self.clear_tab_button)
        top_button_layout.addWidget(self.clear_db_button)

        self.tabs = QtWidgets.QTabWidget()
        main_layout.addLayout(top_button_layout)
        main_layout.addWidget(self.tabs)

        self.tab_artists = self.create_table_tab("Artists")
        self.tab_exhibits = self.create_table_tab("Exhibits")
        self.tab_users = self.create_table_tab("Users")
        self.tab_events = self.create_table_tab("Events")
        self.tab_user_events = self.create_table_tab("Registrations")

        self.tabs.addTab(self.tab_artists, "Artists")
        self.tabs.addTab(self.tab_exhibits, "Exhibits")
        self.tabs.addTab(self.tab_users, "Users")
        self.tabs.addTab(self.tab_events, "Events")
        self.tabs.addTab(self.tab_user_events, "Registrations")

        central_widget = QtWidgets.QWidget()
        central_widget.setLayout(main_layout)
        self.setCentralWidget(central_widget)

    def create_table_tab(self, table_name):
        tab = QtWidgets.QWidget()
        layout = QtWidgets.QVBoxLayout()

        table_widget = QtWidgets.QTableWidget()
        table_widget.horizontalHeader().setSectionResizeMode(QtWidgets.QHeaderView.Stretch)
        layout.addWidget(table_widget)

        buttons_layout = QtWidgets.QHBoxLayout()
        add_button = QtWidgets.QPushButton(f"Add an {table_name.lower()[:-1]}")
        view_button = QtWidgets.QPushButton(f"View {table_name.lower()}")
        search_button = QtWidgets.QPushButton(f"Search in {table_name.lower()}")
        update_button = QtWidgets.QPushButton(f"Update {table_name.lower()[:-1]}")
        delete_button = QtWidgets.QPushButton(f"Delete {table_name.lower()[:-1]}")
        buttons_layout.addWidget(add_button)
        buttons_layout.addWidget(view_button)
        buttons_layout.addWidget(search_button)
        buttons_layout.addWidget(update_button)
        buttons_layout.addWidget(delete_button)

        layout.addLayout(buttons_layout)
        tab.setLayout(layout)

        add_button.clicked.connect(lambda: self.add_record(table_name))
        view_button.clicked.connect(lambda: self.view_records(table_name, table_widget))
        search_button.clicked.connect(lambda: self.search_record(table_name, table_widget))
        update_button.clicked.connect(lambda: self.update_record(table_name, table_widget))
        delete_button.clicked.connect(lambda: self.delete_record(table_name, table_widget))

        return tab

    def connect_db(self):
        try:
            conn = psycopg2.connect(
                user='exhibit_user',
                password='1234',
                host='localhost',
                database='virtualexhibit'
            )
            return conn
        except psycopg2.Error as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Database connection error: {str(e)}")
            return None

    def get_input(self, title, label):
        value, ok = QtWidgets.QInputDialog.getText(self, title, label)
        if not ok or not value.strip():
            return None
        return value.strip()

    def clear_database(self):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            cursor.execute("CALL clear_all_tables();")
            conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", "All database tables have been cleared!")
        except Exception as e:
            conn.rollback()
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to clear database: {str(e)}")
        finally:
            cursor.close()
            conn.close()

        for i in range(self.tabs.count()):
            table_name = self.tabs.tabText(i)
            self.view_records(table_name, self.tabs.widget(i).findChild(QtWidgets.QTableWidget))

    def clear_current_tab(self):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            current_tab_index = self.tabs.currentIndex()
            table_name = self.tabs.tabText(current_tab_index)

            cursor.execute("CALL clear_table(%s);", (table_name,))
            conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", f"All records from {table_name} have been cleared!")
        except Exception as e:
            conn.rollback()
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to clear current tab: {str(e)}")
        finally:
            cursor.close()
            conn.close()

        table_widget = self.tabs.currentWidget().findChild(QtWidgets.QTableWidget)
        table_widget.setRowCount(0)
        table_widget.setColumnCount(0)

    def add_record(self, table_name):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            if table_name == "Registrations":
                user_id, ok = QtWidgets.QInputDialog.getInt(self, "Add Registration", "Enter User ID:")
                if not ok:
                    return
                event_id, ok = QtWidgets.QInputDialog.getInt(self, "Add Registration", "Enter Event ID:")
                if not ok:
                    return
                cursor.execute("CALL add_registration(%s, %s);",
                               (user_id, event_id))

            elif table_name == "Artists":
                name = self.get_input("Add Artist", "Enter Name:")
                if not name: return
                country = self.get_input("Add Artist", "Enter Country:")
                if not country: return
                years_active = self.get_input("Add Artist", "Enter Years Active:")
                if not years_active: return
                biography = self.get_input("Add Artist", "Enter Biography:")
                if not biography: return
                cursor.execute("CALL add_artist(%s, %s, %s, %s);",
                               (name, country, years_active, biography))

            elif table_name == "Exhibits":
                title = self.get_input("Add Exhibit", "Enter Title:")
                if not title: return
                artist_id, ok = QtWidgets.QInputDialog.getInt(self, "Add Exhibit", "Enter Artist ID:")
                if not ok: return
                year_created, ok = QtWidgets.QInputDialog.getInt(self, "Add Exhibit", "Enter Year Created:")
                if not ok: return
                style = self.get_input("Add Exhibit", "Enter Style:")
                if not style: return
                description = self.get_input("Add Exhibit", "Enter Description:")
                if not description: return

                cursor.execute("CALL add_exhibit(%s, %s, %s, %s, %s);",
                               (title, artist_id, year_created, style, description))

            elif table_name == "Users":
                name = self.get_input("Add User", "Enter Name:")
                if not name: return
                email = self.get_input("Add User", "Enter Email:")
                if not email: return
                cursor.execute("CALL add_user(%s, %s);",
                               (name, email))

            elif table_name == "Events":
                title = self.get_input("Add Event", "Enter Title:")
                if not title: return
                date = self.get_input("Add Event", "Enter Date (YYYY-MM-DD):")
                if not date: return
                time = self.get_input("Update Event", "Enter Time (HH:MM):")
                if not time: return
                location = self.get_input("Add Event", "Enter Location:")
                if not location: return
                organizer = self.get_input("Add Event", "Enter Organizer:")
                if not organizer: return
                cursor.execute(
                    "CALL add_event(%s, %s, %s, %s, %s);",
                    (title, date, time, location, organizer))

            elif table_name == "Registration":
                user_id, ok = QtWidgets.QInputDialog.getInt(self, "Add EventID", "Enter UserID:")
                if not ok: return
                event_id, ok = QtWidgets.QInputDialog.getInt(self, "Add UserID", "Enter EventID:")
                if not ok: return
                cursor.execute("CALL add_registration(%s, %s);",
                               (user_id, event_id))

            conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", f"Record added to {table_name}")
            self.view_records(table_name, self.tabs.currentWidget().findChild(QtWidgets.QTableWidget))
        except Exception as e:
            conn.rollback()
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to add record: {str(e)}")
        finally:
            cursor.close()
            conn.close()

    def update_record(self, table_name, table_widget):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            if table_name == "Artists":
                artist_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Artist", "Enter ArtistID:")
                if not ok: return
                name = self.get_input("Update Artist", "Enter Name:")
                if not name: return
                country = self.get_input("Update Artist", "Enter Country:")
                if not country: return
                years_active = self.get_input("Update Artist", "Enter Years Active:")
                if not years_active: return
                biography = self.get_input("Update Artist", "Enter Biography:")
                if not biography: return

                cursor.execute("CALL update_artist(%s, %s, %s, %s, %s);",
                               (artist_id, name, country, years_active, biography))

            elif table_name == "Exhibits":
                exhibit_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Exhibit", "Enter ExhibitID:")
                if not ok: return
                title = self.get_input("Update Exhibit", "Enter Title:")
                if not title: return
                artist_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Exhibit", "Enter ArtistID:")
                if not ok: return
                year_created, ok = QtWidgets.QInputDialog.getInt(self, "Update Exhibit", "Enter Year Created:")
                if not ok: return
                style = self.get_input("Update Exhibit", "Enter Style:")
                if not style: return
                description = self.get_input("Update Exhibit", "Enter Description:")
                if not description: return

                cursor.execute("CALL update_exhibit(%s, %s, %s, %s, %s, %s);",
                               (exhibit_id, title, artist_id, year_created, style, description))

            elif table_name == "Users":
                user_id, ok = QtWidgets.QInputDialog.getInt(self, "Update User", "Enter UserID:")
                if not ok: return
                name = self.get_input("Update User", "Enter Name:")
                if not name: return
                email = self.get_input("Update User", "Enter Email:")
                if not email: return

                cursor.execute("CALL update_user(%s, %s, %s);",
                               (user_id, name, email))

            elif table_name == "Registrations":
                registration_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Registration", "Enter Registration ID:")
                if not ok: return
                user_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Registration", "Enter new User ID:")
                if not ok: return
                event_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Registration", "Enter new Event ID:")
                if not ok: return

                cursor.execute("CALL update_registration(%s, %s, %s);",
                               (registration_id, user_id, event_id))

            elif table_name == "Events":
                event_id, ok = QtWidgets.QInputDialog.getInt(self, "Update Event", "Enter EventID:")
                if not ok: return
                title = self.get_input("Update Event", "Enter Title:")
                if not title: return
                date = self.get_input("Update Event", "Enter Date (YYYY-MM-DD):")
                if not date: return
                time = self.get_input("Update Event", "Enter Time (HH:MM):")
                if not time: return
                location = self.get_input("Update Event", "Enter Location:")
                if not location: return
                organizer = self.get_input("Update Event", "Enter Organizer:")
                if not organizer: return

                cursor.execute("CALL update_event(%s, %s, %s, %s, %s, %s);",
                               (event_id, title, date, time, location, organizer))

            conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", f"Record updated in {table_name}")
            self.view_records(table_name, table_widget)
        except Exception as e:
            conn.rollback()
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to update record: {str(e)}")
        finally:
            cursor.close()
            conn.close()

    def view_records(self, table_name, table_widget):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            if table_name == "Artists":
                cursor.execute("SELECT * FROM view_artists();")
            elif table_name == "Exhibits":
                cursor.execute("SELECT * FROM view_exhibits();")
            elif table_name == "Users":
                cursor.execute("SELECT * FROM view_users();")
            elif table_name == "Events":
                cursor.execute("SELECT * FROM view_events();")
            elif table_name == "Registrations":
                cursor.execute("SELECT * FROM view_registrations();")
            else:
                QtWidgets.QMessageBox.critical(self, "Error", f"Unknown table: {table_name}")
                return

            rows = cursor.fetchall()

            table_widget.setRowCount(0)
            table_widget.setColumnCount(0)

            if not rows:
                QtWidgets.QMessageBox.information(self, "Info", f"Nothing to view in {table_name}!")
                return

            table_widget.setRowCount(len(rows))
            table_widget.setColumnCount(len(rows[0]))
            table_widget.setHorizontalHeaderLabels([desc[0] for desc in cursor.description])

            for i, row in enumerate(rows):
                for j, col in enumerate(row):
                    table_widget.setItem(i, j, QtWidgets.QTableWidgetItem(str(col)))
        except Exception as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to load records: {str(e)}")
        finally:
            cursor.close()
            conn.close()

    def search_record(self, table_name, table_widget):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            value = None
            if table_name == "Artists":
                value = self.get_input("Search in Artists", "Enter Name:")
                if not value: return
                cursor.execute("SELECT * FROM search_artists(%s);", (value,))

            elif table_name == "Exhibits":
                value = self.get_input("Search in Exhibits", "Enter Title:")
                if not value: return
                cursor.execute("SELECT * FROM search_exhibits(%s);", (value,))

            elif table_name == "Users":
                value = self.get_input("Search in Users", "Enter Name:")
                if not value: return
                cursor.execute("SELECT * FROM search_users(%s);", (value,))

            elif table_name == "Events":
                value = self.get_input("Search in Events", "Enter Title:")
                if not value: return
                cursor.execute("SELECT * FROM search_events(%s);", (value,))

            elif table_name == "Registrations":
                value, ok = QtWidgets.QInputDialog.getInt(self, "Search in Registrations", "Enter UserID:")
                if not ok: return
                cursor.execute("SELECT * FROM search_registrations(%s);", (value,))

            rows = cursor.fetchall()
            table_widget.setRowCount(0)
            table_widget.setColumnCount(0)

            if not rows:
                QtWidgets.QMessageBox.information(self, "Info", "No records found!")
                return

            table_widget.setRowCount(len(rows))
            table_widget.setColumnCount(len(rows[0]))
            table_widget.setHorizontalHeaderLabels([desc[0] for desc in cursor.description])

            for i, row in enumerate(rows):
                for j, col in enumerate(row):
                    table_widget.setItem(i, j, QtWidgets.QTableWidgetItem(str(col)))
        except Exception as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to search records: {str(e)}")
        finally:
            cursor.close()
            conn.close()

    def delete_record(self, table_name, table_widget):
        conn = self.connect_db()
        if conn is None:
            return

        cursor = conn.cursor()
        try:
            choice, ok = QtWidgets.QInputDialog.getItem(
                self, "Delete Record", "Delete by:", ["ID", "Name"], editable=False
            )
            if not ok or not choice:
                return

            if choice == "ID":
                id_field_mapping = {
                    "artists": "delete_from_artists_by_id",
                    "exhibits": "delete_from_exhibits_by_id",
                    "events": "delete_from_events_by_id",
                    "users": "delete_from_users_by_id",
                    "registrations": "delete_from_registrations_by_id"
                }
                procedure_name = id_field_mapping.get(table_name.lower())

                record_id, ok = QtWidgets.QInputDialog.getInt(
                    self, f"Delete {table_name}", f"Enter ID of record to delete:"
                )
                if not ok or not procedure_name:
                    return

                cursor.execute(f"CALL {procedure_name}(%s);", (record_id,))

            elif choice == "Name":
                name_field_mapping = {
                    "artists": "delete_from_artists_by_name",
                    "exhibits": "delete_from_exhibits_by_name",
                    "events": "delete_from_events_by_name",
                    "users": "delete_from_users_by_name",
                    "registrations": "delete_from_registrations_by_userid"
                }
                procedure_name = name_field_mapping.get(table_name.lower())

                name, ok = QtWidgets.QInputDialog.getText(
                    self, f"Delete {table_name}", "Enter Name/Title:"
                )
                if not ok or not name.strip() or not procedure_name:
                    return

                cursor.execute(f"CALL {procedure_name}(%s);", (name.strip(),))

            conn.commit()
            QtWidgets.QMessageBox.information(self, "Success", f"Record deleted from {table_name}")
            self.view_records(table_name, table_widget)

        except Exception as e:
            conn.rollback()
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to delete record: {str(e)}")
        finally:
            cursor.close()
            conn.close()

app = QtWidgets.QApplication([])
window = ExhibitApp()
window.show()
app.exec_()

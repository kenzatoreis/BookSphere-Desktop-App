import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2

class DatabaseManager:
    """ Manage database connection and operations. """
    def __init__(self, host, database, user, password):
        self.conn = None
        self.cursor = None
        try:
            self.conn = psycopg2.connect(host=host, database=database, user=user, password=password)
            self.cursor = self.conn.cursor()
        except psycopg2.Error as e:
            messagebox.showerror("Database Error", f"Error connecting to the database: {e}")

    def execute_query(self, query, params=None, fetch=False):
        """ Execute a query and handle exceptions, returning fetched results if any. """
        try:
            self.cursor.execute(query, params)
            if fetch:
                results = self.cursor.fetchall()
                self.conn.commit()
                return results
            self.conn.commit()
            return True
        except psycopg2.Error as e:
            messagebox.showerror("Database Error", f"Error executing query: {e}")
            self.conn.rollback()
            return False

    def get_tables(self):
        """ Retrieve table names from the database. """
        query = "SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';"
        return [result[0] for result in self.execute_query(query, fetch=True)]

    def close(self):
        """ Close the cursor and connection. """
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()

class BookSphereApp(tk.Tk):
    def __init__(self, db_manager):
        super().__init__()
        self.db_manager = db_manager
        self.geometry("1200x800")
        self.title("BookSphere App")

        if not self.db_manager.conn:
            self.destroy()  # Close the app if connection was not successful

        self.style = ttk.Style(self)
        self.style.theme_use('clam')  # Use 'clam' or any other available theme
        self.style.configure('TNotebook.Tab', padding=[10, 10])
        self.style.configure('TButton', padding=[10, 5], font=('Arial', 10))

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(expand=True, fill='both')
        self.create_tabs()

    def create_tabs(self):
        tables = self.db_manager.get_tables()  # Dynamically get table names

        for table_name in tables:
            tab = ttk.Frame(self.notebook, padding="10 10 10 10")
            self.notebook.add(tab, text=table_name)
            self.create_table_widgets(tab, table_name)

    def create_table_widgets(self, parent, table_name):
        # Get columns dynamically for accuracy
        query = f"SELECT column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name='{table_name}';"
        columns = [result[0] for result in self.db_manager.execute_query(query, fetch=True)]

        center_frame = ttk.Frame(parent, padding="10 10 10 10")
        center_frame.pack(pady=20, padx=20, expand=True)
        entries = {}

        for idx, field in enumerate(columns):
            label = ttk.Label(center_frame, text=field, font=('Arial', 10, 'bold'))
            entry = ttk.Entry(center_frame, font=('Arial', 10))
            label.grid(row=idx, column=0, sticky="e", padx=5, pady=2)
            entry.grid(row=idx, column=1, sticky="w", padx=5, pady=2)
            entries[field] = entry

        button_frame = ttk.Frame(center_frame)
        button_frame.grid(row=len(columns), column=0, columnspan=2, pady=10)

        insert_button = ttk.Button(button_frame, text="Insert", command=lambda: self.insert_record(table_name, entries))
        insert_button.pack(side="left", padx=5)
        view_button = ttk.Button(button_frame, text="View", command=lambda: self.view_records(table_name, columns))
        view_button.pack(side="left", padx=5)
        update_button = ttk.Button(button_frame, text="Update", command=lambda: self.update_record(table_name, entries))
        update_button.pack(side="left", padx=5)

    def insert_record(self, table_name, entries):
        fields = list(entries.keys())
        values = [entries[field].get() for field in fields]
        placeholders = ', '.join(['%s'] * len(values))
        query = f"INSERT INTO {table_name} ({', '.join(fields)}) VALUES ({placeholders});"
        if self.db_manager.execute_query(query, values):
            messagebox.showinfo("Success", f"Record inserted into {table_name} table.")
            for entry in entries.values():
                entry.delete(0, tk.END)
        else:
            messagebox.showerror("Error", f"Failed to insert record into {table_name} table.")

    def view_records(self, table_name, fields):
        query = f"SELECT * FROM {table_name};"
        results = self.db_manager.execute_query(query, fetch=True)
        if results:
            self.show_table_results(table_name, fields, results)

    def show_table_results(self, table_name, fields, results):
        top = tk.Toplevel(self)
        top.title(f"Records of {table_name}")
        for idx, field in enumerate(fields):
            ttk.Label(top, text=field, relief=tk.RIDGE, width=20, font=('Arial', 10, 'bold')).grid(row=0, column=idx)
        for row_idx, row in enumerate(results, start=1):
            for col_idx, value in enumerate(row):
                ttk.Label(top, text=value, relief=tk.RIDGE, width=20).grid(row=row_idx, column=col_idx)

    def update_record(self, table_name, entries):
        primary_key = list(entries.keys())[0]  # Assuming the first column is the primary key
        primary_key_value = entries[primary_key].get()
        update_values = {key: entry.get() for key, entry in entries.items() if key != primary_key}
        set_clause = ', '.join([f"{key} = %s" for key in update_values.keys()])
        query = f"UPDATE {table_name} SET {set_clause} WHERE {primary_key} = %s;"
        values = list(update_values.values()) + [primary_key_value]
        if self.db_manager.execute_query(query, values):
            messagebox.showinfo("Success", f"Record updated in {table_name} table.")
        else:
            messagebox.showerror("Error", f"Failed to update record in {table_name} table.")

    def on_closing(self):
        """ Handle window closing. """
        self.db_manager.close()
        self.destroy()

if __name__ == "__main__":
    db_manager = DatabaseManager(host="localhost", database="BookSphere", user="postgres", password="admin")
    app = BookSphereApp(db_manager)
    app.protocol("WM_DELETE_WINDOW", app.on_closing)
    app.mainloop()

import glob as g
import pandas as pd
import os
import mysql.connector

#Chemin du dossier principal
folder_path = 'Weather Data'

#Liste pour stocker les données de tous les fichiers CSV
all_data = []

#Parcours récursif des dossiers et fichiers
for root, dirs, files in os.walk(folder_path):
    for file in files:
        if file.endswith('.csv'):
            file_path = os.path.join(root, file)
            data = pd.read_csv(file_path, low_memory=False)
            #data = data.isnull()


            missing_values = ["n/a", "nan", "--", ",,", "", "NaN"]
            data = pd.read_csv(file_path, na_values=missing_values, low_memory=False, dtype=str)
            #mean = data['TMIN'].mean(skipna=True)
            median = data['TMIN'].mode()
            data['TMIN'].fillna(median, inplace=True)

            #mean = data['TMAX'].mean(skipna=True)
            median = data['TMAX'].mode()
            data['TMAX'].fillna(median, inplace=True)


            #mean = data['TAVG'].mean(skipna=True)
            median = data['TAVG'].mode()
            data['TAVG'].fillna(median, inplace=True)

            #mean = data['PRCP'].mean(skipna=True)
            median = data['PRCP'].mode()
            data['PRCP'].fillna(median, inplace=True)

            median = data['STATION'].mode()
            data['STATION'].fillna(median, inplace=True)

            median = data['NAME'].mode()
            data['NAME'].fillna(median, inplace=True)

            median = data['LATITUDE'].mode()
            data['LATITUDE'].fillna(median, inplace=True)

            median = data['LONGITUDE'].mode()
            data['LONGITUDE'].fillna(median, inplace=True)

            
            # print(data)
            
            # for column in data.columns:
            #     data['TMIN'] = pd.to_numeric(data['TMIN'], errors='coerce', downcast='integer')
            #     data['TMAX'] = pd.to_numeric(data['TMAX'], errors='coerce', downcast='integer')
            #     data['TAVG'] = pd.to_numeric(data['TAVG'], errors='coerce', downcast='integer')
            #     data['PRCP'] = pd.to_numeric(data['PRCP'], errors='coerce', downcast='integer')
            #     data['STATION'] = data['STATION'].astype(str)
            #     data['NAME'] = data['NAME'].astype(str)
            #     data['LATITUDE'] = data['LATITUDE'].astype(str)
            #     data['LONGITUDE'] = data['LONGITUDE'].astype(str)
            #     data['ELEVATION'] = data['ELEVATION'].astype(str)

            data = data.dropna()

            

            db_connection = mysql.connector.connect(
                host = "localhost",
                user = "root",
                password = "",
                database = "weather_datawarehouse"
            )
            
            cursor = db_connection.cursor()
            

            # Préparer les données pour l'insertion
            values2 = data[['STATION', 'NAME', 'LATITUDE', 'LONGITUDE', 'ELEVATION']].values.tolist()
            values3 = data[['DATE']].values.tolist()

            for _, row in data.iterrows():

                cursor.execute("INSERT IGNORE INTO station (station, name, latitude, longitude, elevation) VALUES (%s, %s, %s, %s, %s)", 
                            (row['STATION'], row['NAME'], row['LATITUDE'], row['LONGITUDE'], row['ELEVATION'],))

                # Récupérer l'ID de la station insérée
                cursor.execute("SELECT LAST_INSERT_ID() AS ID")
                station_id = cursor.fetchone()[0]

                # Insérer des données dans la table Dim_Date en ignorant les duplicatas
                cursor.execute("INSERT IGNORE INTO date (date) VALUES (%s)", (row['DATE'],))
                cursor.execute("SELECT LAST_INSERT_ID() AS ID")
                date_id = cursor.fetchone()[0]

                # Insérer des données dans la table Fact_Weather en utilisant les identifiants de station et de date correspondants
                cursor.execute("INSERT INTO fact_temperature (id_date, id_station, PRCP, TAVG, TMAX, TMIN) VALUES (%s, %s, %s, %s, %s, %s)", 
                                (date_id, station_id, row['PRCP'], row['TAVG'], row['TMAX'], row['TMIN']))


            db_connection.commit()
            cursor.close()
            db_connection.close()
            #print(data)
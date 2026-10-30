PRAGMA foreign_keys = ON

CREATE TABLE Person (
    person_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    passport_data TEXT UNIQUE,
    phone TEXT,
    email TEXT
);

CREATE TABLE Administrator (
    person_id INTEGER PRIMARY KEY,
    subordinates_count INTEGER,
    FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE
);

CREATE TABLE Operator (
    person_id INTEGER PRIMARY KEY,
    id_admin INTEGER,
    quarterly_sales_sum REAL,
    FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE,
    FOREIGN KEY (id_admin) REFERENCES Administrator(person_id)
);

CREATE TABLE Client (
    person_id INTEGER PRIMARY KEY,
    benefits TEXT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE
);

CREATE TABLE Transport_Type (
    id_trans_type INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE Room_Type (
    id_room_type INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE Meal_Type (
    id_meal_type INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE Tour_Type (
    id_tour_type INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE Destination (
    id_destination INTEGER PRIMARY KEY,
    country TEXT,
    city TEXT,
    climate TEXT,
    language TEXT,
    currency TEXT,
    additional_info TEXT
);

CREATE TABLE Tour (
    id_tour INTEGER PRIMARY KEY,
    id_destination INTEGER,
    id_tour_type INTEGER, 
    tour_name TEXT,
    duration_days INTEGER,
    start_date TEXT,
    end_date TEXT,
    available_seats INTEGER,
    base_price REAL,
    FOREIGN KEY (id_destination) REFERENCES Destination(id_destination),
    FOREIGN KEY (id_tour_type) REFERENCES Tour_Type(id_tour_type)
);

CREATE TABLE Transfer (
    id_transfer INTEGER PRIMARY KEY,
    id_tour INTEGER UNIQUE,
    id_trans_type INTEGER, 
    dep_time TEXT,
    arr_time TEXT,
    cost REAL,
    FOREIGN KEY (id_tour) REFERENCES Tour(id_tour),
    FOREIGN KEY (id_trans_type) REFERENCES Transport_Type(id_trans_type)
);

CREATE TABLE Hotel (
    id_hotel INTEGER PRIMARY KEY,
    hotel_name TEXT,
    address TEXT,
    rating_stars INTEGER,
    description TEXT,
    photos TEXT
);

CREATE TABLE Tour_Hotel (
    id_tour INTEGER,
    id_hotel INTEGER,
    price REAL,
    id_meal_type INTEGER, 
    id_room_type INTEGER, 
    PRIMARY KEY (id_tour, id_hotel),
    FOREIGN KEY (id_tour) REFERENCES Tour(id_tour),
    FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel),
    FOREIGN KEY (id_meal_type) REFERENCES Meal_Type(id_meal_type),
    FOREIGN KEY (id_room_type) REFERENCES Room_Type(id_room_type)
);

CREATE TABLE Tour_Order (
    order_number INTEGER PRIMARY KEY,
    client_person_id INTEGER,   
    operator_person_id INTEGER, 
    id_tour INTEGER,
    order_date TEXT,
    discount_applied REAL,
    total_amount REAL,
    adults_count INTEGER,
    children_count INTEGER,
    status TEXT,
    special_notes TEXT,
    FOREIGN KEY (client_person_id) REFERENCES Client(person_id),
    FOREIGN KEY (operator_person_id) REFERENCES Operator(person_id),
    FOREIGN KEY (id_tour) REFERENCES Tour(id_tour)
);

CREATE TABLE Review (
    id_review INTEGER PRIMARY KEY,
    client_person_id INTEGER, 
    id_hotel INTEGER,
    review_text TEXT,
    rating INTEGER CHECK(rating >= 1 AND rating <= 5),
    publication_date TEXT,
    FOREIGN KEY (client_person_id) REFERENCES Client(person_id),
    FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel)
);
    
INSERT INTO Transport_Type (type_name) VALUES 
('Самолет'), ('Автобус'), ('Корабль'), ('Поезд'), ('Минивэн');

INSERT INTO Room_Type (type_name) VALUES 
('Стандарт'), ('Люкс'), ('Семейный'), ('Эконом'), ('Президентский');

INSERT INTO Meal_Type (type_name) VALUES 
('Только завтраки'), ('Шведский стол'), ('Не предусмотрено'), ('Полупансион'), ('Все включено');

INSERT INTO Tour_Type (type_name) VALUES 
('Однодневный тур'), ('Экскурсионный тур'), ('Авторский'), ('Пляжный отдых'), ('Экстремальный');

INSERT INTO Person (first_name, second_name, last_name, passport_data, phone, email) VALUES 
('Иван', 'Иванович', 'Иванов', 'MP1234567', '+48111222333', 'ivanov@test.com'), 
('Анна', 'Сергеевна', 'Смирнова', 'MP7654321', '+48999888777', 'anna@test.com'), 
('Мария', 'Петровна', 'Сидорова', 'MP0001112', '+48555666777', 'maria@test.com');

INSERT INTO Administrator (person_id, subordinates_count) VALUES (1, 5);
INSERT INTO Operator (person_id, id_admin, quarterly_sales_sum) VALUES (2, 1, 15000.50);
INSERT INTO Client (person_id, benefits) VALUES (3, 'VIP-клиент, скидка 10%');

INSERT INTO Destination (country, city, climate, language, currency, additional_info) VALUES 
('Польша', 'Закопане', 'Умеренный', 'Польский', 'PLN', 'Горнолыжный курорт'),
('Испания', 'Барселона', 'Средиземноморский', 'Испанский', 'EUR', 'Виза обязательна');

INSERT INTO Hotel (hotel_name, address, rating_stars, description) VALUES 
('Tatra Resort', 'ul. Krupowki 10, Zakopane', 4, 'Отличный вид на горы'),
('Sea View Hotel', 'Rambla 15, Barcelona', 5, 'Первая линия');

INSERT INTO Tour (id_destination, id_tour_type, tour_name, duration_days, start_date, end_date, available_seats, base_price) VALUES 
(1, 2, 'Выходные в Татрах', 3, '2026-11-15', '2026-11-18', 20, 1200.00),
(2, 4, 'Каникулы в Каталонии', 7, '2026-12-01', '2026-12-08', 15, 3500.00);

INSERT INTO Tour_Hotel (id_tour, id_hotel, price, id_meal_type, id_room_type) VALUES 
(1, 1, 800.00, 1, 1),
(2, 2, 2500.00, 5, 2);

INSERT INTO Transfer (id_tour, id_trans_type, dep_time, arr_time, cost) VALUES 
(1, 2, '2026-11-15 08:00', '2026-11-15 14:00', 150.00),
(2, 1, '2026-12-01 10:00', '2026-12-01 13:30', 850.00);

INSERT INTO Tour_Order (client_person_id, operator_person_id, id_tour, order_date, discount_applied, total_amount, adults_count, children_count, status) VALUES 
(3, 2, 1, '2026-10-30', 0, 1200.00, 2, 0, 'Оплачен');

INSERT INTO Review (client_person_id, id_hotel, review_text, rating, publication_date) VALUES 
(3, 1, 'Прекрасный отель, но было холодно', 4, '2026-11-20');
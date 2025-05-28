-- Switch to the correct database
USE apartment_db;

-- Table: users
CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'tenant') NOT NULL
);

-- Table: admins
CREATE TABLE admins (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Table: rooms
CREATE TABLE rooms (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    number VARCHAR(10) NOT NULL,
    floor INT(11) NOT NULL,
    status ENUM('vacant','occupied','maintenance') DEFAULT 'vacant',
    description TEXT,
    image_path VARCHAR(255)
);

-- Table: tenants
CREATE TABLE tenants (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    contact VARCHAR(100),
    address VARCHAR(255),
    apartment_id INT(11),
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (apartment_id) REFERENCES rooms(id) ON DELETE SET NULL
);

-- Table: applications
CREATE TABLE applications (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    room_id INT(11) NOT NULL,
    applicant_name VARCHAR(100) NOT NULL,
    applicant_email VARCHAR(100) NOT NULL,
    applicant_phone VARCHAR(50) NOT NULL,
    status ENUM('pending','approved','declined') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- Table: room_applications
CREATE TABLE room_applications (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    room_id INT(11),
    applicant_name VARCHAR(100),
    applicant_email VARCHAR(100),
    applicant_phone VARCHAR(30),
    message TEXT,
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL
);

-- Table: payments
CREATE TABLE payments (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT(11),
    amount DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL DEFAULT CURDATE(),
    status ENUM('pending','paid') DEFAULT 'pending',
    payment_date DATETIME,
    description TEXT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE SET NULL
);

-- Table: maintenance
CREATE TABLE maintenance (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    apartment_id INT(11),
    tenant_id INT(11),
    description TEXT,
    status ENUM('open','in_progress','closed') DEFAULT 'open',
    date_reported DATE NOT NULL,
    FOREIGN KEY (apartment_id) REFERENCES rooms(id) ON DELETE SET NULL,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE SET NULL
);

-- Table: maintenance_requests
CREATE TABLE maintenance_requests (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT(11) NOT NULL,
    request_text TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    apartment_id INT(11),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (apartment_id) REFERENCES rooms(id) ON DELETE SET NULL
);

-- Table: messages
CREATE TABLE messages (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT(11) NOT NULL,
    sender ENUM('tenant','admin') NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read TINYINT(1) DEFAULT 0,
    is_from_admin TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);

-- Table: notifications
CREATE TABLE notifications (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT(11) NOT NULL,
    message VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    is_read TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    admin_id INT(11),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE SET NULL
);

-- Table: admin_notifications
CREATE TABLE admin_notifications (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11) NOT NULL,
    message VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    is_read TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    tenant_id INT(11),
    FOREIGN KEY (user_id) REFERENCES admins(id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE SET NULL
);

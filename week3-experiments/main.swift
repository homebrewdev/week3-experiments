//
//  main.swift
//  week3-experiments
//
//  Created by Egor Devyatov on 21.06.2019.
//  Copyright © 2019 homework. All rights reserved.
//

import Foundation

// MARK: - приведение типов
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley"),
    Song(name: "My name is", artist: "Eminem")
]
// тип "library" выведен как [MediaItem]
// Используйте оператор проверки типа (is) для проверки того, соответствует ли тип экземпляра типам какого-то определенного подкласса. Оператор проверки типа возвращает true, если экземпляр имеет тип конкретного подкласса, false, если нет.
// Пример ниже определяет две переменные movieCount и songCount, которые считают число экземпляров Movie и экземпляров Song в массиве library:

var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("В Media библиотеке содержится \(movieCount) фильма и \(songCount) песни")
// Выведет "В Media библиотеке содержится 2 фильма и 4 песни"

//Константа или переменная определенного класса может фактически ссылаться на экземпляр подкласса. Там, где вы считаете, что это тот случай, вы можете попробовать привести тип к типу подкласса при помощи оператора понижающего приведения (as? или as!).
//Из-за того, что понижающее приведение может провалиться, оператор приведения имеет две формы. Опциональная форма (as?), которая возвращает опциональное значение типа, к которому вы пытаетесь привести. И принудительная форма (as!), которая принимает попытки понижающего приведения и принудительного разворачивания результата в рамках одного составного действия.

for item in library {
    if let movie = item as? Movie {
        print("Фильм '\(movie.name)' директор: \(movie.director)")
    } else if let song = item as? Song {
        print("Песня '\(song.name)' певец: \(song.artist)")
    }
}
// Фильм 'Casablanca' директор: Michael Curtiz
// Песня 'Blue Suede Shoes' певец: Elvis Presley
// Фильм 'Citizen Kane' директор: Orson Welles
// Песня 'The One And Only' певец: Chesney Hawkes
// Песня 'Never Gonna Give You Up' певец: Rick Astley
// Песня 'My name is' певец: Eminem

// MARK: - Обработки ошибок
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// В приведенном ниже примере VendingMachine класс имеет vend(itemNamed: ) метод, который генерирует соответствующую VendingMachineError, если запрошенный элемент недоступен, его нет в наличии, или имеет стоимость, превышающую текущий депозит:

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11),
        "Ватрушка": Item(price: 2, count: 0)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}
// проверка работы выброса ошибок
let vendingApparat = VendingMachine()
vendingApparat.coinsDeposited = 10

// функция покупки пользователем товара в вендинг аппарате
func buyItem (itemName: String) throws {
    do {
        try vendingApparat.vend(itemNamed: itemName)
    } catch VendingMachineError.invalidSelection {
        print("Данного товара '\(itemName)' нет в вендинг автомате!")
    } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
        print("Недостаточно средств, необходимо добавить \(coinsNeeded) монет")
    } catch VendingMachineError.outOfStock {
        print("Извините, но на данный момент в вендинговом аппарате закончился товар '\(itemName)'.\nВ ближайшее время оператор пополнит асортимент! ")
    }
}

// пусть пользователь что-нибудь купит уже в нашем вендинг аппарате
try buyItem(itemName: "Шаурма") // Данного товара 'Шаурма' нет в вендинг автомате!

try buyItem(itemName: "Candy Bar") // Недостаточно средств, необходимо добавить 2 монет

try buyItem(itemName: "Ватрушка") // Извините, но на данный момент в вендинговом аппарате закончился товар 'Ватрушка'.
// В ближайшее время оператор пополнит асортимент!


// MARK: - протоколы. Работа с протоколами
// создадим протокол, требующий содержать у экземпляров поле fullName
protocol MustHaveFullName {
    var fullName: String { get }
}

struct Person: MustHaveFullName {
    var fullName: String
}

let perc = Person(fullName: "Джо")
print("Персонажа зовут: \(perc.fullName)")  // Персонажа зовут: Джо


// еще один пример протокола посложнее
class Starship: MustHaveFullName {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName равен "USS Enterprise"

//Класс реализует требуемое свойство fullName, в качестве вычисляемого свойства только для чтения (для космического корабля). Каждый экземпляр класса Starship хранит обязательный name и опциональный prefix. Свойство fullName использует значение prefix, если оно существует и устанавливает его в начало name, чтобы получилось целое имя для космического корабля.

// как определять методы в протоколе
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()

print("Случайное число = \(generator.random()) и еще одно случ. число = \(generator.random())")
// Случайное число = 0.3746499199817101 и еще одно случ. число = 0.729023776863283

//Если подкласс переопределяет назначенный инициализатор суперкласса и так же реализует соответствующий инициализатор протоколу, то обозначьте реализацию инициализатора сразу двумя модификаторами required и override:
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // реализация инициализатора…
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" от соответсвия протоколу SomeProtocol; "override" от суперкласса SomeSuperClass
    required override init() {
        // тут прописываем реализацию инициализатора…
    }
}

// Вот пример использования протокола в качестве типа:
class Dice {
    let sidesOfDice: Int
    let generator: RandomNumberGenerator
    init(sidesOfDice: Int, generator: RandomNumberGenerator) {
        self.sidesOfDice = sidesOfDice
        self.generator = generator
    }
    // функция бросания кости
    func roll() -> Int {
        return Int((generator.random()*Double(sidesOfDice)) + 1)
    }
}

// проверяем работу класса Dice и функции roll()
var dice6 = Dice(sidesOfDice: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("При броске 6-гранной кости выпало число: \(dice6.roll())")
}
// При броске 6-гранной кости выпало число: 3
// При броске 6-гранной кости выпало число: 5
// При броске 6-гранной кости выпало число: 4
// При броске 6-гранной кости выпало число: 5
// При броске 6-гранной кости выпало число: 4


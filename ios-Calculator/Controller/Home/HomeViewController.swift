//
//  HomeViewController.swift
//  ios-Calculator
//
//  Created by Ivan Valero on 15/10/2021.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    // Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - Variables
    
    private var total: Double = 0                   // Total - inicializandola a cero
    private var temp: Double = 0                    // Valor temporal por pantalla que no tiene por que ser igual al valor final
    private var operating = false                   // Indicar si se a seleccionado un operador (operaciones de la calculadora)
    private var decimal = false                     // Indicar si el valor es decimal
    private var operation: OperationType = .none    // Operación actual
    
    // MARK: - Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator! // Tipo de decimal . o , segun país de origen
    private let kMaxLenght = 9                                       // Cantidad máximas de caracteres soportado por la calcu
    private let kTotal = "total"
    
    
    // se eliminan estas dos consatantes ya que el totalFormateador se encarga de contar la cantidad de digitos
    // private let kMaxValue: Double =  999999999                     // 9 nueves valor máximo
    // private let kMinValue : Double = 0.00000001
    
    private enum OperationType {
        case none, addiction, substraction, multiplication, division, percent
    }
    
    // Formateadores de numeros
    
    // Formateo de valores auxiliar
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        // número máximo de números enteros
        formatter.maximumIntegerDigits = 100
        // número mínimo de números en forma de fracción
        formatter.minimumFractionDigits = 0
        // número máximo de numeros en forma de fracción
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Creamos un nuevo formateador para que calcule cuantos digitos se han marcado
    // y si son más de 9 colocar la "e" como explonencial
    
    // duplicamos el formateador auxiliar
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        // número máximo de números enteros
        formatter.maximumIntegerDigits = 100
        // número mínimo de números en forma de fracción
        formatter.minimumFractionDigits = 0
        // número máximo de numeros en forma de fracción
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de los valores por pantalla por defecto
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formateo de valores por pantalla en formato científico
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    

    
    // MARK: - Initiaization
        
    // instanciar un controlador de vista
    
    init() {
        // llamar a la super clase de nuetro ViewController
        // es la manera de asociar un xib a un controlador
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    // es la primera operación que se ejecuta al pintar la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
         

        // mostrar separador decimar segun region por pantalla
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        // antes de llamar a resultado, guardamos el último valor total
        total = UserDefaults.standard.double(forKey: kTotal)
        // mostrar resultado por pantalla
        result()
    }
    
    // funcion que se llama justo antes que se muestre la pantalla
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // UI
        // todo lo visual que veremos por pantalla
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
    }
    
    // MARK: - Button Actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        
        clear()
        
        // dejamos el efecto de brillo al final por que nos interesa ejecutar primero la lógica
        sender.shine()
    }
    
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        
        // cambiar de valor con el signo
        temp = temp * (-1)
        
        // ahora mostrarlo en pantalla
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        
        // en caso de haber una operacion antes y no precionamos el = para finalizarla
        // entonces, primero llamaremos a la funcion result() para finalizarla
        
        if operation != .percent {
            result()
        }
        
        operating = true
        operation = .percent
        result()
        
        
        sender.shine()
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        
        result()
        
        sender.shine()
    }
    
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .substraction
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .division
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        
        // valor asociado a la variable temp
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        // si no estamos operando
        if !operating && currentTemp.count >= kMaxLenght{
            return
        }
        
        // la label es la pantalla superior donde aparecen los resultados que comienza con 0
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    
    @IBAction func numberAction(_ sender: UIButton) {
        // una misma funcion para todos los botones
        // usando el tag en el inspector para cada uno
        
        
        operatorAC.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLenght{
            return
        }
        
        // una vez usado el formateador nuevo TotalFormatter, volvemos a ejecutar el formateador anterior
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Hemos seleccionado una operacion
        if operating {
            // si total es igual a 0, entonce(?) nuestro total sera nuestro temp, en caso contratrio (:) será nuestro total
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        // Hemos seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        // Ahora ver que numero hemos seleccionado
        
        let number = sender.tag
        // temp = double
        // CurrentTemp = String
        // number = entero
        // con ! desempaquetaremos el valor ya que si o si va a devolver un numero y no hay riesgo de que sea nulo
        temp = Double(currentTemp + String(number))!
        // imprimir por pantalla -> resultado temp
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        
        // sender es un UIButton
        // tag va a asignar cada numero
        // print(sender.tag)
        // brillo del boton
        sender.shine()
    }
    
    // Limpia los valores AC
    
    private func clear(){
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        }else {
            total = 0
            result()
        }
    }
    
    // Obtiene el resultado final
    private func result() {
        
        switch operation {
        
        case .none:
            // no hacemos nada
            break
        case .addiction:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            total = temp / 100
            total = temp
            break
        }
        
        // Formateo de pantalla
        
        if let currenTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currenTotal.count > kMaxLenght {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        // set double ya que es el tipo de nuestra variable total
        // con esta linea de codigo guardamos el último resultado que ejecutó la app
        UserDefaults.standard.set(total, forKey: kTotal)
       
        // se remplaza por la funcion anterior
        
//        if total <= kMaxValue || total >= kMinValue {
//            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
//        }
        print("Total: \(total)")
    }
    
    private func selectVisualOperation() {
        // si no estamos operando
        if !operating {
            // no estamos operando
            operatorAddition.selectOperation(false)
            operatorSubstraction.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        } else {
            switch operation {
            case .none, .percent:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .addiction:
                operatorAddition.selectOperation(true)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .substraction:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .multiplication:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivision.selectOperation(false)
                break
            case .division:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(true)
                break
                
            }
        }
    }
    
}

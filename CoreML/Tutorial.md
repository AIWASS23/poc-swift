# Create ML

## Introdução

O Create ML é um framework do Swift que permite que desenvolvedores treinem e construam modelos de Machine Learning em seus aplicativos sem a necessidade de ter conhecimentos profundos em ciência de dados ou estatística.

É uma parte integrante do ecossistema de Machine Learning da Apple e pode ser usado em combinação com outras ferramentas e frameworks como o Core ML e o Create ML.

## Utilização

Machine Learning é feito em duas etapas, primeiro treinamos o modelo e, em seguida, pedimos ao modelo para fazer previsões. 

- O treinamento é o processo do computador que analisa todos os nossos dados para descobrir a relação entre todos os valores que temos.
- A previsão é feita no dispositivo aonde nós o alimentamos com o modelo treinado e ele usará os resultados anteriores para fazer estimativas sobre novos dados.

## Create ML App

Para iniciar o aplicativo do Create ML, basta abrirmos o menu do ***Xcode*** > ***Open Developer Tool*** > ***Create ML***:

![Screenshot 2023-04-05 at 14.40.49.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ead6d711-b49c-425c-b5c3-186ec8af22a4/Screenshot_2023-04-05_at_14.40.49.png)

Na próxima tela criaremos um novo documento, e escolheremos entre os templates disponíveis. Para nosso exemplo utilizaremos o *Tabular Regression*:

![Screenshot 2023-04-05 at 14.43.13.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ae15a236-6793-464d-8078-53edc6c2ae75/Screenshot_2023-04-05_at_14.43.13.png)

Então escolheremos um nome para nosso arquivo e um local para salvá-lo.

## Training Data

A primeira etapa é fornecer ao Create ML alguns dados de treinamento, para isso utilizarei um arquivo .csv que já contenha esses dados. Para selecionar o arquivo clicamos no ***+*** em Training Data:

![Screenshot 2023-04-05 at 14.48.05.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d20b28b9-2dca-49c0-9574-8eef31888322/Screenshot_2023-04-05_at_14.48.05.png)

E carregamos o arquivo:

![Screenshot 2023-04-05 at 14.48.13.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/22ffa3b0-1f92-41c0-bfd3-e212c152152f/Screenshot_2023-04-05_at_14.48.13.png)

## Target & Features

A próxima tarefa é decidir o *target*, que é o valor que queremos que o computador aprenda a prever, e as *features*, que são os valores que queremos que o computador inspecione para prever o alvo:

![32.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/aa3960e0-0932-4b80-85d8-d761fd671e6c/32.png)

Após configurarmos as opções desejadas, clicamos em *Train*, na parte superior da tela e rapidamente teremos a mensagem que o treinamento foi concluído com sucesso. 

## Export

Agora que nosso modelo está treinado, pressionamos *Get* para exportá-lo para seu local de preferência, e dessa forma podemos usá-lo em nosso projeto:

![Screenshot 2023-04-05 at 14.56.35.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/83f2f0f7-baa3-47dd-9e1e-4510a598151b/Screenshot_2023-04-05_at_14.56.35.png)

Para adicionar o arquivo gerado ao projeto, clicamos com o botão direito no menu de arquivos do Xcode > ***Add Files***:

![Screenshot 2023-04-06 at 12.42.38.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6e6be3d5-230e-4d38-bc4e-b978c9b0be76/Screenshot_2023-04-06_at_12.42.38.png)

![Screenshot 2023-04-06 at 12.46.56.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/593b1938-1a0f-4f1c-9b76-95eaa52b1eda/Screenshot_2023-04-06_at_12.46.56.png)

## Utilização

Segue a seguir um exemplo que realiza a conexão entre o SwiftUI e o Core ML.

Primeiro importaremos o CoreML ao projeto:

```swift
import CoreML
```

Código:

Obs. Alterei o nome do arquivo para SleepCalculator.

```swift
func calculateBedtime() {
    do {
         let config = MLModelConfiguration()
         let model = try SleepCalculator(configuration: config)

         let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
         let hour = (components.hour ?? 0) * 60 * 60
         let minute = (components.minute ?? 0) * 60
            
         let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
         let sleepTime = wakeUp - prediction.actualSleep
            
         alertTitle = "Your ideal bedtime is…"
         alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
    
		} catch {
         alertTitle = "Error"
         alertMessage = "Sorry, there was a problem calculating your bedtime."
    }
    showingAlert = true
}
```

---
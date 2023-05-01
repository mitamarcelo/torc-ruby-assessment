# Torc-ruby-assessment
This is an assessment for torc company

## About the problem

The problem presented receives inputs in the format of a list of products with quantity and value and expects that we return a receipt for that list of products applying the taxes into each product.

The choice of implementation was to create a controller that will receive an array of lines that describes the products. The idea is that it can be used on differnt kinds of applications just by coupling this controller to the method that you want to get the input. For simplicity, I've read the input from a input file located on the root of this project and then I pass it to the controller.

Another point to consider here is how to identify that a product is exempt from taxes. To do that I've created a repository interface that implements a method of fetching key words that will describe products that are in a list for exemptions. The controller then receives the repository and use it to get this list of exemptions. That way we can create other ways of getting this list of exempts without having to change the controller logic. The same structure was used to the output generator, in this case, I've used the Receipt repository interface to create a way of output the recipt.

In order of simplicity, I'm outputting the receipt into a file with "receipt_${timestamp}" format, but as explained before, it can be easily exchanged by another repository that can export the receipt in another way.

## Usage

Give execution permission for the init file:

```
chmod +x init
```

then run: 

```
./init
```

On this project we have a input file that contains one of the examples described on the assessment page. You can change the input file to test other values.

## Automated tests

In order to test the application, just install rspec gem:

```
gem install rspec
```

Then, you can simply run in the root of the project:

```
rspec
```

## Final Considerations

As the list of goods that are exempt depends on the kind of each product, I've created a short list of key words that contemplates the examples given on the assessment. This list is far from complete and won't exempt books, food and medical goods that doesn't contain 'book', 'chocolate' and 'pill' on its description. The idea is to add as many words as posible to contemplate all the goods that are exempt. In an ideal world, this list could be given by an API with some AI that returns if a item is exempt. For now, it's only a list with words locally placed.
# enginizer_flutter

## About flutter

Welcome to flutter. They may seem like :O, but building apps seems to be silky smooth

Some details about the ecosystem
0. Flutter stands for two things: a Widget library and a framework written in Dart
1. Flutter uses Dart (a strongly typed language developed by Google) as a programming language
2. Flutter UI is made up of Widgets (same  concept as UI components)
3. Flutter state is very well managed by the framework, as Flutter has both StatelessWidget (a widget that just renders data) and StatefulWidget (a widget that can handle state changes) as extendable classes.
4. Flutter is a widget oriented framework.
* Widgets can have mandatory params
```
class SomeWidget {
  Function doSmthHandler;
  
  SomeWidget({@required this.doSmthHandler});
  
  doSmth(){
    doSmthHandler();
  }

```
* The interface can be customised based on screen size and platform:
```
// Responsive settings
...
height: MediaQuery.of(context).size.height
...

// Platform settings
Platform.isAndroid ? AndroidCard() : iOSCard();
```
5. Flutter usable [modules.cars.widgets tutorial](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/14950970#overview) 

## About Dart

0. Dart is a strongly typed programming language developed by Google
1. Why Dart? [This article](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf) shared some info with regards to why they chose Dart
2. Dart can be fun. For trying stuff out, you can use [Dartpad](https://dartpad.dartlang.org)
3. Dart 2 is mostly declarative :

* Creating a class
```
class Model{

String prop1;
int prop2;

Model({this.prop1, this.prop2}); 
Model.prop1Constructor(this.prop1, {this.prop2 = 0}); // for prop2 we  use a default value of 0

//Geter implementation
String get somePropGetter { 
    return this.prop1;
}

//Setter implementation (to assign mod.somePropSetter = 'crr';)
String set somePropSetter(val){
    return this.prop1 = val;
}

}
```
* Instantiating a model
```
void main() {
  var model = Model(prop1: 'SomeModel', prop2: 7);
  var model2 = Model.prop1Constructor('SomeOtherModel');
  
  print('Model has prop1=${model.prop1} and prop2=${model.prop2}');
  print('Mode2 has prop1=${model2.prop1} and prop2=${model2.prop2}');
}
```

* Passing a callback function to an object
```
// This is how state is passed from children to  parent modules.cars.widgets in flutter
class SomeWidget {
  Function doSmthHandler;
  
  SomeWidget({this.doSmthHandler});
  
  doSmth(){
    doSmthHandler();
  }
}

void main() {
  var widget = SomeWidget(doSmthHandler: _handlerFunction);
  widget.doSmth();
}

_handlerFunction(){
  print('Sent as a param for handling');
}

```
* Final vs const
```
In Dart, you have control of making something immutable at both value and poinetr level.

var q = const [];
// q is thus a variable that gets an immutable list as a value

In Dat, 'final' controls a runtime constant value
final String someVar = 'lala';
  
```
* Creating a widget with requird params
```
In Dart, modules.cars.widgets can have mandatory parameters:

class SomeWidget {
  Function doSmthHandler;
  
  SomeWidget({@required this.doSmthHandler});
  
  doSmth(){
    doSmthHandler();
  }
}

```

# Versioning strategy (Gitflow)
  - master     --> release branch
  - develop    --> development branch 
  - demo       --> for presentational use only (@ end of sprint, functionality is demo-ed here)
  - feature    --> used for creating new features
  - components --> used for continuous of UI components
  - bugfix     --> used for fixing up found issues or bugs
  - refactor   --> used for refactoring

Ex. `https://www.atlassian.com/git/tutorials/comparing-workflows#gitflow-workflow`

# Git naming strategy
Naming should be based on : ${branchType}/${asanaTaskId}/${humanlyReadableCommentInCamelCase}

Ex. `feature/bosch-047/toolForm` or `bugfix/bosch-048/toolDetails`

Since components are not directly part of a specific asana task id, they exist as separate branched

Ex. `component/table` or `component/input`


# D.O.D (for each story/deliverable)
When implementing a task, each dev should:
  - implement UI screens based on provided moqups
  - implement UI functionality based on story description/provided docs/what was groomed/moqups intuition
  - implement according API calls. If API is not available, then fakeBackend interceptor implementation should be used.
  - happy flow dev testing (++ since we don't have QA yet)
  - pull request with at least one reviewer approval. Branch should be instantly mergeable
  - update story status in monday

## Useful places
Monday: `https://redabac.monday.com/boards/389692425`
Moqups: `https://xd.adobe.com/view/1f267900-798e-4a62-734d-f5a3d0738f45-6917/`

## Meets + sprint
Sprint duration: `2 weeks`
Weekly status call: `Every monday & Thursday from  14:00PM` 
Demo: `Once every two weeks on friday @ 09:30`

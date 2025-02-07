

#  VIPER

On the presenter using a `didSet { view?.didChange(sections: sections!) }`. Notifying the view delegates
 presentation logic to the View (which is wrong)
It should be instead `didSet { view?.isLoading(shown: loading) }`, where the presenter tells it what to do




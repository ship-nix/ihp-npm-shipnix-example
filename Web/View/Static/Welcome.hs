module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
    <h1 class="text-2xl font-bold mb-8">IHP with React and Tailwind</h1>
    <div id="react-app"></div>
|]
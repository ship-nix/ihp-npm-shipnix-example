import { createRoot } from "react-dom/client";
import * as React from "react";

$(document).on("ready turbolinks:load", function () {
  // This is called on the first page load *and* also when the page is changed by turbolinks
  function App() {
    const [count, setCount] = React.useState(0);
    const increaseCount = () => setCount(count + 1);
    return (
      <div>
        <h2 className="text-lg font-bold">React App</h2>
        <div>Counter: {count}</div>
        <button
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          onClick={increaseCount}
        >
          Increase count
        </button>
      </div>
    );
  }
  const container = document.getElementById("react-app");
  const root = createRoot(container); // createRoot(container!) if you use TypeScript
  root.render(<App />);
});

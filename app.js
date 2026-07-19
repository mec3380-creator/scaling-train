// 브라우저 localStorage에 저장할 때 사용할 키
const STORAGE_KEY = "haru-todolist";

// 화면에 필요한 HTML 요소들
const form = document.getElementById("todo-form");
const input = document.getElementById("todo-input");
const list = document.getElementById("todo-list");
const countEl = document.getElementById("todo-count");
const emptyMessage = document.getElementById("empty-message");

// 할 일 배열. 각 항목 예: { id: 123, text: "장보기", done: false }
let todos = loadTodos();

// 페이지가 열리면 바로 목록을 그려줍니다.
render();

// 폼 제출(추가 버튼 또는 Enter) 시 할 일을 추가합니다.
form.addEventListener("submit", (event) => {
  event.preventDefault(); // 페이지가 새로고침되지 않게 막기

  const text = input.value.trim();
  if (!text) {
    return;
  }

  const newTodo = {
    id: Date.now(), // 간단한 고유 번호
    text,
    done: false,
  };

  todos.unshift(newTodo); // 최신 할 일을 위에 추가
  saveTodos();
  render();

  input.value = "";
  input.focus();
});

// 목록에서 체크박스 클릭 / 삭제 버튼 클릭을 처리합니다.
list.addEventListener("click", (event) => {
  const target = event.target;

  // 완료 체크
  if (target.classList.contains("todo-check")) {
    const id = Number(target.closest(".todo-item").dataset.id);
    todos = todos.map((todo) =>
      todo.id === id ? { ...todo, done: !todo.done } : todo
    );
    saveTodos();
    render();
    return;
  }

  // 삭제
  if (target.classList.contains("delete-btn")) {
    const item = target.closest(".todo-item");
    const id = Number(item.dataset.id);

    item.classList.add("leaving");

    window.setTimeout(() => {
      todos = todos.filter((todo) => todo.id !== id);
      saveTodos();
      render();
    }, 200);
  }
});

// 할 일 목록을 화면에 그립니다.
function render() {
  list.innerHTML = "";

  todos.forEach((todo) => {
    const li = document.createElement("li");
    li.className = `todo-item${todo.done ? " done" : ""}`;
    li.dataset.id = String(todo.id);

    li.innerHTML = `
      <input
        type="checkbox"
        class="todo-check"
        ${todo.done ? "checked" : ""}
        aria-label="완료 표시"
      />
      <span class="todo-text"></span>
      <button type="button" class="delete-btn" aria-label="삭제">삭제</button>
    `;

    // 텍스트는 textContent로 넣어 XSS를 막습니다.
    li.querySelector(".todo-text").textContent = todo.text;
    list.appendChild(li);
  });

  const total = todos.length;
  const doneCount = todos.filter((todo) => todo.done).length;

  if (total === 0) {
    countEl.textContent = "할 일 0개";
  } else {
    countEl.textContent = `할 일 ${total}개 · 완료 ${doneCount}개`;
  }

  emptyMessage.classList.toggle("hidden", total > 0);
}

// localStorage에서 할 일 불러오기
function loadTodos() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      return [];
    }

    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) {
      return [];
    }

    return parsed
      .filter(
        (item) =>
          item &&
          typeof item.id === "number" &&
          typeof item.text === "string" &&
          typeof item.done === "boolean"
      )
      .map((item) => ({
        id: item.id,
        text: item.text,
        done: item.done,
      }));
  } catch (error) {
    console.warn("저장된 할 일을 불러오지 못했습니다.", error);
    return [];
  }
}

// localStorage에 할 일 저장하기
function saveTodos() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
}

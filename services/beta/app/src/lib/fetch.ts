async function get(url: string) {
  const result = await fetch(url);
  return await result.json();
}

async function post(url: string, payload: Record<string, unknown>) {
  const result = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  return await result.json();
}

export { get, post };

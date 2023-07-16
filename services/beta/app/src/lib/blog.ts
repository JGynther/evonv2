import { get } from "$lib/fetch";

const getAllBlogs = async () => {
  return await get("/api/blog");
};

export { getAllBlogs };

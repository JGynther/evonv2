import { get } from "$lib/fetch";

type Blog = {
  content: string;
  title: string;
  createdAt: string;
  authors: string[];
  id: string;
};

type Author = {
  name: string;
  description: string;
  id: string;
};

const getAllBlogs = async (): Promise<Blog[]> => {
  return await get("/api/blog");
};

const getBlogById = async (id: string): Promise<Blog> => {
  return await get(`/api/blog/${id}`);
};

const getAuthorById = async (id: string): Promise<Author> => {
  return await get(`/api/author/${id}`);
};

const batchGetAuthor = async (ids: string[]): Promise<Author[]> => {
  return await Promise.all(ids.map(async (id) => await getAuthorById(id)));
};

export { getAllBlogs, getBlogById, getAuthorById, batchGetAuthor };
export type { Blog, Author };

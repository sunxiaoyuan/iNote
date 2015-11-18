//
//  SZYDataBaseDef.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  本地数据库宏定义文件

#ifndef iNote_SZYDataBaseDef_h
#define iNote_SZYDataBaseDef_h

/****************************************************************
 *
 *  create table
 *
 ****************************************************************/
//笔记
#define CREATE_NOTE_TABLE (@"CREATE TABLE NOTE_DATA_TABLE(note_id TEXT,noteBook_id_belonged TEXT,user_id_belonged TEXT,title TEXT,mendTime TEXT,content TEXT,image TEXT,video TEXT,isFavorite TEXT)")
#define DELETE_ALL_NOTES (@"DELETE FROM NOTE_DATA_TABLE")
#define DELETE_ONE_NOTE (@"DELETE FROM NOTE_DATA_TABLE WHERE note_id = ?")

//笔记本
#define CREATE_NOTE_BOOK_TABLE (@"CREATE TABLE NOTE_BOOK_DATA_TABLE(noteBook_id TEXT,user_id_belonged TEXT,title TEXT,noteNumber TEXT,isPrivate TEXT)")

#define DELETE_ALL_NOTE_BOOKS (@"DELETE FROM NOTE_BOOK_DATA_TABLE")

#define DELETE_ONE_NOTE_BOOK (@"DELETE FROM NOTE_BOOK_DATA_TABLE WHERE noteBook_id = ?")

/**************************************
 *
 *  insert table
 *
 ***************************************/
//笔记
#define INSERT_ONE_NOTE (@"INSERT INTO NOTE_DATA_TABLE(note_id,noteBook_id_belonged,user_id_belonged,title,mendTime,content,image,video,isFavorite) VALUES(?,?,?,?,?,?,?,?,?)")

//笔记本
#define INSERT_ONE_NOTE_BOOK (@"INSERT INTO NOTE_BOOK_DATA_TABLE(noteBook_id,user_id_belonged,title,noteNumber,isPrivate) VALUES(?,?,?,?,?)")


/**************************************************
 *
 *  select table
 *
 ***************************************************/
//笔记
#define SELECT_ALL_NOTES (@"SELECT * FROM NOTE_DATA_TABLE ORDER BY mendTime DESC")
#define SELECT_ONE_NOTE (@"SELECT * FROM NOTE_DATA_TABLE WHERE note_id = ?")
#define SELECT_NOTES_BY_NOTEBOOKID (@"SELECT * FROM NOTE_DATA_TABLE WHERE noteBook_id_belonged = ?")
#define Select_Notes_By_Favorite (@"SELECT * FROM NOTE_DATA_TABLE WHERE isFavorite = ?")

//笔记本
#define SELECT_ALL_NOTE_BOOKS (@"SELECT * FROM NOTE_BOOK_DATA_TABLE")
#define SELECT_ONE_NOTE_BOOK (@"SELECT * FROM NOTE_BOOK_DATA_TABLE WHERE noteBook_id = ?")
#define SELECT_NOTE_BOOK_BY_USERID (@"SELECT * FROM NOTE_BOOK_DATA_TABLE WHERE user_id_belonged = ?")


/**************************************************
 *
 *  update table
 *
 ***************************************************/
//笔记
#define UPDATE_NOTE (@"UPDATE NOTE_DATA_TABLE SET note_id = ?, noteBook_id_belonged = ?,user_id_belonged = ?,title = ?,mendTime = ?,content = ?,image = ?,video = ?,isFavorite = ? WHERE note_id = ?")

//笔记本
#define UPDATE_NOTE_BOOK (@"UPDATE NOTE_BOOK_DATA_TABLE SET noteBook_id = ?,user_id_belonged = ?,title = ?,noteNumber = ?,isPrivate = ?")

#endif

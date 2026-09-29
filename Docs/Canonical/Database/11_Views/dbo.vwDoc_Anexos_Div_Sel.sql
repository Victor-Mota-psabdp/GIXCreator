SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_help Doc_Anexos_Div
CREATE  VIEW [dbo].[vwDoc_Anexos_Div_Sel]
AS
	Select
		convert(varchar(25),'Saved')					[Status],
		right('000' + convert(int,DA.Item_Doc),3)		[Item],
		right('000' + Convert(varchar(3),DA.Id_Doc),3)	[Doc Client Code],
		TD.Nome_DC										[Doc Client Name],		
		convert(varchar(10),Dt_Anexo,103)				[Insert Date],
		DA.Nome_Arquivo									[File Name],	
		convert(varchar(10),Dt_Venc,103)				[Due Date],
		DA.cd_usuario									[User Code],
		Nome_usuario									[User Name],
		convert(varchar(500),'')						[fileOriginPath],
		convert(varchar(500),'')						[fileDestinationPath],
		DA.Id_Tipo_Doc									[Type ID]
	from 
		Doc_Anexos_Div DA  With(nolock)
		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_Doc
		left join Usuario U on U.cd_usuario = DA.cd_usuario
	--Select
	--		convert(varchar(25),'Saved')					[Status],
	--		right('000' + convert(int,Item_Doc),3)			[Item],
	--		right('000' + Convert(varchar(3),DA.Id_Doc),3)	[ID_DC],
	--		DA.Id_Tipo_Doc									[Id_Tipo_Doc],
	--		TD.Nome_DC										[Type Doc],
	--		convert(varchar(10),Dt_Anexo,103)				[Sent Date],
	--		Nome_Arquivo									[File],		
	--		convert(varchar(10),Dt_Venc,103)				[Due Date],
	--		DA.cd_usuario									[cd user],
	--		Nome_usuario									[User],
	--		convert(varchar(500),'')						[Origin],
	--		convert(varchar(500),'')						[Destin]
 --		from 
	--		Doc_Anexos_Div DA  With(nolock)
	--		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_Doc
	--		left join Usuario U on U.cd_usuario = DA.cd_usuario






GO

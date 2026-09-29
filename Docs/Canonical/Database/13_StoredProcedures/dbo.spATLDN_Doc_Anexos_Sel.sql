SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLDN_Doc_Anexos_Sel]
(	
	@Num_Proc	VarChar(16),
	@ID_DC		Int,
	@Tipo		char(1)
)
AS

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
SP_HELP DOC_ANEXOS
*/
IF @Tipo = 'C' or @Tipo = 'D'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation ],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination]			
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U on U.cd_usuario = DA.cd_usuario
			left join Usuario UC on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			Num_Proc=@Num_Proc and Num_Proc <> ''
	order by 2
	
End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation ],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination]			
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U on U.cd_usuario = DA.cd_usuario
			left join Usuario UC on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			Num_Proc=@Num_Proc and Num_Proc <> ''
			AND DA.ID_DC= @ID_DC
		order by 2
	End
		
		



/*
ALTER Procedure [dbo].[spATLDN_DocAnexos_Sel]
(
	
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
IF @Tipo = 'C' or @Tipo = 'D'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[ID_DC],
			TD.Nome_DC										[Type Doc],
			--right('000' + Convert(varchar(3),DA.ID_DC),3) + '-'+ TD.Nome_DC	[Type Doc],
			convert(varchar(10),Dt_Envio,103)				[Sent Date],
			Nome_Arquivo									[File],		
			convert(varchar(10),dt_creacao,103)				[Creation Date],
			DA.cd_usuario									[cd user],
			Nome_usuario									[User],
			convert(varchar(500),'')												[Origin],
			convert(varchar(500),'')												[Destin]
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U on U.cd_usuario = DA.cd_usuario
		where 
			Num_Proc=@Num_Proc and Num_Proc <> ''
	order by 2
	
End
	
--IF @Tipo = 'N' or @Tipo = 'O'
--	Begin
--	End
		
		



*/
GO

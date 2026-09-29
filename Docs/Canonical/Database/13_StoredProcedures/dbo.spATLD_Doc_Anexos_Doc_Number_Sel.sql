SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spATLD_Doc_Anexos_Doc_Number_Sel]
(	
	@Num_Proc	VarChar(16),
	@Id_DC		int,
	@Doc_Number varchar(200), 
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

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type Name],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User Name],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation Name],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination],
			TD.DMS_Code										[DMS Code]	
			,DA.Numero_Doc									[Doc_Number]
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U with(nolock) on U.cd_usuario = DA.cd_usuario
			left join Usuario UC with(nolock) on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			DA.Num_Proc=@Num_Proc and DA.Num_Proc <> ''
	order by 2
	
End

IF @Tipo = 'C' or @Tipo = 'D'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type Name],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User Name],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation Name],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination],
			TD.DMS_Code										[DMS Code]
			,DA.Numero_Doc									[Doc_Number]
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U with(nolock) on U.cd_usuario = DA.cd_usuario
			left join Usuario UC with(nolock) on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			DA.Num_Proc=@Num_Proc and DA.Num_Proc <> '' and DA.Id_DC =@Id_DC
	order by 2

End

IF @Tipo = 'N' or @Tipo = 'O'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type Name],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User Name],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation Name],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination],
			TD.DMS_Code										[DMS Code]	
			,DA.Numero_Doc									[Doc_Number]
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U with(nolock) on U.cd_usuario = DA.cd_usuario
			left join Usuario UC with(nolock) on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			Num_Proc=@Num_Proc and Num_Proc <> ''
			AND DA.ID_DC= @ID_DC
			And da.Numero_Doc = @Doc_Number
		order by 2
	End

	
IF @Tipo = 'R'
	Begin	
		Select
			convert(varchar(25),'Saved')					[Status],
			DA.Num_Proc										[JOB],
			right('000' + convert(int,Item_Doc),3)			[Item],
			right('000' + Convert(varchar(3),DA.ID_DC),3)	[Doc Type Code],
			TD.Nome_DC										[Doc Type Name],		
			DA.Nome_Arquivo									[File Name],
			convert(varchar(10),DA.Dt_Envio,103)			[Sent Date],
			DA.cd_usuario									[User Code],
			U.Nome_usuario									[User Name],	
			convert(varchar(10),DA.Anexado_em,103)			[Included_In],
			convert(varchar(10),DA.dt_creacao,103)			[Creation Date],
			DA.cd_usuario_creacao							[User Creation Code],
			UC.Nome_usuario									[User Creation Name],	
			convert(varchar(500),'')						[Origin],
			convert(varchar(500),'')						[Destination],
			convert(varchar(200),'Origin')					[File Name Destination],
			TD.DMS_Code										[DMS Code]
			,DA.Numero_Doc									[Doc_Number]
 		from 
			Doc_Anexos DA  With(nolock)
			Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
			left join Usuario U with(nolock) on U.cd_usuario = DA.cd_usuario
			left join Usuario UC with(nolock) on UC.cd_usuario = DA.cd_usuario_creacao
		where 
			DA.Num_Proc like @Num_Proc and DA.Num_Proc <> '' 
			and DA.Id_DC = @Id_DC
			and year(DA.Anexado_em) >= year(getdate()) - 5
	order by 2
	
End
	

GO

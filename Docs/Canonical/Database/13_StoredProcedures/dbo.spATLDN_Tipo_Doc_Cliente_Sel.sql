SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_Cliente
--[spATLDN_Tipo_Doc_Cliente_Sel] '1','','D'
CREATE procedure [dbo].[spATLDN_Tipo_Doc_Cliente_Sel](
	@ID_DC char(3),
	@Nome_DC varchar(50),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			right('000' + Convert(varchar(3),ID_DC),3) [Code],
			Nome_DC				[Nome],
			Nome_DC				[Doc Type Name],
			Smart_Doc			[Smart Doc],
			DMS_Code			[DMS Code],
			Data_Obrigatoria	[Required Date],
			Numero_Obrigatorio	[Required Number],
			Doc_Anexo			[Attached Document],
			Replica				[Replica],
			House				[House],
			Historico			[Historic],
			GenericReference	[GenericReference],
			Data_Habilita		[Data_Habilita],
			Numero_Habilita		[Numero_Habilita],
			Multiplos			[Multiplos]
		from 
			Tipo_Doc_Cliente with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			right('000' + Convert(varchar(3),ID_DC),3) [Code],
			Nome_DC				[Nome],
			Nome_DC				[Doc Type Name],
			Smart_Doc			[Smart Doc],
			DMS_Code			[DMS Code],
			Data_Obrigatoria	[Required Date],
			Numero_Obrigatorio	[Required Number],
			Doc_Anexo			[Attached Document],
			Replica				[Replica],
			House				[House],
			Historico			[Historic],
			GenericReference	[GenericReference],
			Data_Habilita		[Data_Habilita],
			Numero_Habilita		[Numero_Habilita],
			Multiplos			[Multiplos]
		from 
			Tipo_Doc_Cliente with(nolock)
		where 
			ID_DC = @ID_DC
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			right('000' + Convert(varchar(3),ID_DC),3) [Code],
			Nome_DC				[Nome],
			Nome_DC				[Doc Type Name],
			Smart_Doc			[Smart Doc],
			DMS_Code			[DMS Code],
			Data_Obrigatoria	[Required Date],
			Numero_Obrigatorio	[Required Number],
			Doc_Anexo			[Attached Document],
			Replica				[Replica],
			House				[House],
			Historico			[Historic],
			GenericReference	[GenericReference],
			Data_Habilita		[Data_Habilita],
			Numero_Habilita		[Numero_Habilita],
			Multiplos			[Multiplos]
		from 
			Tipo_Doc_Cliente with(nolock)
		where 
			Nome_DC = @Nome_DC
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select
			right('000' + Convert(varchar(3),ID_DC),3) [Code],
			Nome_DC				[Nome],
			Nome_DC				[Doc Type Name],
			Smart_Doc			[Smart Doc],
			DMS_Code			[DMS Code],
			Data_Obrigatoria	[Required Date],
			Numero_Obrigatorio	[Required Number],
			Doc_Anexo			[Attached Document],
			Replica				[Replica],
			House				[House],
			Historico			[Historic],
			GenericReference	[GenericReference],
			Data_Habilita		[Data_Habilita],
			Numero_Habilita		[Numero_Habilita],
			Multiplos			[Multiplos]
		from 
			Tipo_Doc_Cliente with(nolock)	
		where 
			Nome_DC = @Nome_DC AND ID_DC <> @ID_DC
	End

if @Tipo = 'P'
	Begin
		select
			right('000' + Convert(varchar(3),ID_DC),3) [Code],
			Nome_DC				[Nome],
			Nome_DC				[Doc Type Name],
			Smart_Doc			[Smart Doc],
			DMS_Code			[DMS Code],
			Data_Obrigatoria	[Required Date],
			Numero_Obrigatorio	[Required Number],
			Doc_Anexo			[Attached Document],
			Replica				[Replica],
			House				[House],
			Historico			[Historic],
			GenericReference	[GenericReference],
			Data_Habilita		[Data_Habilita],
			Numero_Habilita		[Numero_Habilita],
			Multiplos			[Multiplos]
		from 
			Tipo_Doc_Cliente with(nolock)
		where 
			Smart_Doc = @Nome_DC
	End
GO

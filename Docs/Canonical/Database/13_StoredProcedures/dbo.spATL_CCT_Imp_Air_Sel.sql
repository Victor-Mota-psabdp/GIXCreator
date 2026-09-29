SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help CCT_Imp_Air
CREATE PROCEDURE [dbo].[spATL_CCT_Imp_Air_Sel]
(
	@Id				int,	
	@Num_Proc		varchar(16),
	@FileType		varchar(25),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select 			
			C.Num_Proc		[Num_Proc],
			C.FileType		[FileType],
			C.HAWB			[HAWB],
			C.MAWB			[MAWB],
			C.Dt_Ins		[Dt_Ins],
			C.Dt_Sent		[Dt_Sent],
			C.XML_Sent		[XML_Sent],
			C.File_Name		[File_Name],
			C.MessageHeaderDocument_ID	[MessageHeaderDocument_ID],
			C.XML_Return	[XML_Return],
			C.ProtocolNumber [ProtocolNumber],
			C.Status		[Status],
			C.CPF			[CPF],
			C.CNPJ			[CNPJ],
			C.ErrorList		[ErrorList]
		from CCT_Imp_Air C  with(nolock)					
		where
			ID = @ID and Num_Proc = @Num_Proc and [FileType] = @FileType
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 			
			C.Num_Proc		[Num_Proc],
			C.FileType		[FileType],
			C.HAWB			[HAWB],
			C.MAWB			[MAWB],
			C.Dt_Ins		[Dt_Ins],
			C.Dt_Sent		[Dt_Sent],
			C.XML_Sent		[XML_Sent],
			C.File_Name		[File_Name],
			C.MessageHeaderDocument_ID	[MessageHeaderDocument_ID],
			C.XML_Return	[XML_Return],
			C.ProtocolNumber [ProtocolNumber],
			C.Status		[Status],
			C.CPF			[CPF],
			C.CNPJ			[CNPJ],
			C.ErrorList		[ErrorList]
		from CCT_Imp_Air C  with(nolock)					
		where
			ID = @ID 

        
	
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			C.Num_Proc		[Num_Proc],
			C.FileType		[FileType],
			C.HAWB			[HAWB],
			C.MAWB			[MAWB],
			C.Dt_Ins		[Dt_Ins],
			C.Dt_Sent		[Dt_Sent],
			C.XML_Sent		[XML_Sent],
			C.File_Name		[File_Name],
			C.MessageHeaderDocument_ID	[MessageHeaderDocument_ID],
			C.XML_Return	[XML_Return],
			C.ProtocolNumber [ProtocolNumber],
			C.Status		[Status],
			C.CPF			[CPF],
			C.CNPJ			[CNPJ],
			C.ErrorList		[ErrorList]
		from CCT_Imp_Air C  with(nolock)					
		where
			Num_Proc = @Num_Proc and [FileType] = @FileType
	End	
	

	

GO

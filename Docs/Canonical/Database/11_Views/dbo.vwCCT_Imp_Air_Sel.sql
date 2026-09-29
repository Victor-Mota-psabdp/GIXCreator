SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwCCT_Imp_Air_Sel]
AS
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




GO

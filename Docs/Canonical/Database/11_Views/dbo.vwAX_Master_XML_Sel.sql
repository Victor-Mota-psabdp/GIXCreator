SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwAX_Master_XML_Sel]
AS
		select 			
			E.ID_AX								[Code],
			E.num_proc							[JOB],
			E.Tipo								[Instruction Type Code],	
			C.Nome_Tp_Instrucao					[Instruction Type Name],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			E.MessageId							[MessageId],
			E.Verificado						[Verified]
		from AX_Master_XML E  with(nolock)
			Join  Tipo_Instrucao C with(nolock) on E.Tipo=C.Cd_Tp_Instrucao		

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help E_AirFreight_XML
CREATE PROCEDURE [dbo].[spATL_E_AirFreight_XML_Sel]
(
	@ID_AirFreight			bigint,	
	@Num_Proc				varchar(16),
	@HAWB_MAWB				varchar(50),
	@Tipo					char(1)
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
			E.ID_AirFreight						[Id], 		
			E.num_proc							[JOB],
			E.HAWB_MAWB							[HAWB_MAWB],		
			E.XML_DOC							[XML_DOC],		
			E.Nome_Arquivo						[File Name],
			E.Dt_Envio							[Sent Date],
			E.Status_Envio						[Status_Envio],
			E.XML_DOC_XML_Retorno				[XML_DOC_XML_Retorno],
			E.Dt_Ins_Retorno					[Insert Return Date],
			E.XML_DOC_Retorno					[XML_DOC_Retorno]
		from 
			E_AirFreight_XML E  with(nolock)			
		where
			E.ID_AirFreight = @ID_AirFreight
			and E.Dt_Envio is null			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 			
			E.ID_AirFreight						[Id], 		
			E.Num_Proc							[JOB],
			E.HAWB_MAWB							[HAWB_MAWB],		
			E.XML_DOC							[XML_DOC],		
			E.Nome_Arquivo						[File Name],
			E.Dt_Envio							[Sent Date],
			E.Status_Envio						[Status_Envio],
			E.XML_DOC_XML_Retorno				[XML_DOC_XML_Retorno],
			E.Dt_Ins_Retorno					[Insert Return Date],
			E.XML_DOC_Retorno					[XML_DOC_Retorno]
		from 
			E_AirFreight_XML E  with(nolock)			
		where
			E.Num_Proc = @Num_Proc		     
	
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			E.ID_AirFreight						[Id], 		
			E.Num_Proc							[JOB],
			E.HAWB_MAWB							[HAWB_MAWB],		
			E.XML_DOC							[XML_DOC],		
			E.Nome_Arquivo						[File Name],
			E.Dt_Envio							[Sent Date],
			E.Status_Envio						[Status_Envio],
			E.XML_DOC_XML_Retorno				[XML_DOC_XML_Retorno],
			E.Dt_Ins_Retorno					[Insert Return Date],
			E.XML_DOC_Retorno					[XML_DOC_Retorno]
		from 
			E_AirFreight_XML E  with(nolock)			
		where
			E.HAWB_MAWB = @HAWB_MAWB
	End	

GO

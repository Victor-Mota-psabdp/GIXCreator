SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--BR1ATL_Oracle_0_1813298_AR_80abe347-7e47-43a3-a367-8343342dc504_20251227.xml
--select
--E.MessageId,
--E.Nome_Arquivo,
--SUBSTRING(E.Nome_Arquivo,28,36),
--isnull(E.MessageId,RIGht(left(E.Nome_Arquivo,49),36))
--,
--* 
--from AX_DOC_XML_Oracle E with(nolock)

CREATE PROCEDURE [dbo].[spAX_DOC_XML_Oracle_Sel]
(
	@ID_AX				bigint,
	@Cancel				Bit,
	@Tipo				char(1)
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
sp_help AX_DOC_XML_Oracle

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select
			E.ID_AX								[Code],			
			Cancel								[Cancel],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			isnull(E.Verificado,0)				[Verified],
			isnull(E.MessageId,SUBSTRING(E.Nome_Arquivo,28,36))	[MessageId],	
			E.Dt_Reenvio						[Resend Date],
			E.ErrorMessage						[ErrorMessage]
		from 
			AX_DOC_XML_Oracle E  with(nolock)
		where
			E.ID_AX = @ID_AX		
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			E.ID_AX								[Code],			
			Cancel								[Cancel],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			isnull(E.Verificado,0)				[Verified],
			isnull(E.MessageId,SUBSTRING(E.Nome_Arquivo,28,36))	[MessageId],				
			E.Dt_Reenvio						[Resend Date],
			E.ErrorMessage						[ErrorMessage]
		from 
			AX_DOC_XML_Oracle E  with(nolock)
		where
			E.ID_AX=@ID_AX and E.Cancel  = @Cancel
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			E.ID_AX								[Code],			
			Cancel								[Cancel],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			isnull(E.Verificado,0)				[Verified],
			isnull(E.MessageId,SUBSTRING(E.Nome_Arquivo,28,36))	[MessageId],			
			E.Dt_Reenvio						[Resend Date],
			E.ErrorMessage						[ErrorMessage]
			,DATEADD(day,1,E.Dt_Envio)			[DATEADD],
			 DATEADD(MONTH,-1,GETDATE())		[MONTHADD],
			 DATEADD(hour,6,E.Dt_Envio)			[DATEADDHour]
		from 
			AX_DOC_XML_Oracle E  with(nolock)
		Where
			--DATEADD(hour,6,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()
			--and 
			isnull(E.Verificado,0) = 0
		order by
			E.Dt_Envio		
	End	

	

	
/*
select
			E.ID_AX								[Code],
			E.num_proc							[JOB],
			E.Cd_tp_Tx_ATL						[Charge Type Code],	
			C.Nome_Tp_TX						[Charge Type Name],
			E.DC								[D/C Code],
			D.Descricao_TP_DC							[D/C Name],
			Cancel								[Cancel],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			--BR1ATL_V2_AP_dd0967a3-34b0-4a9b-86a8-3844f420d9e8_20230116.xml
			isnull(E.MessageId,RIGht(left(E.Nome_Arquivo,49),36))	[MessageId],
			isnull(E.Verificado,0)				[Verified],
			E.Dt_Reenvio						[Resend Date],
			DATEADD(day,1,E.Dt_Envio)			[DATEADD],
			 DATEADD(MONTH,-1,GETDATE())		[MONTHADD],
			 DATEADD(hour,6,E.Dt_Envio)			[DATEADDHour],
			E.ErrorMessage						[ErrorMessage]
		from AX_DOC_XML_New E  with(nolock)
			Join  Tipo_Taxa C with(nolock) on E.Cd_tp_Tx_ATL=C.Cd_tp_Tx		
			Join  Tipo_DC D with(nolock) on E.DC=D.Cd_Tp_DC	
		where			
			--DATEADD(day,1,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()
			DATEADD(hour,6,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()

			--E.dt_envio between '2023-01-16 00:00:000' and '2023-01-16 23:32:08.240' 
			--DATEADD(day,1,E.Dt_Envio) between  GETDATE()- 2 and getdate()
			and isnull(E.Verificado,0) = 0
		order by
			E.Dt_Envio
*/
GO

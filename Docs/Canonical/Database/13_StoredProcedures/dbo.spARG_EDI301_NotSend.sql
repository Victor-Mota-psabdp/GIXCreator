SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Use ATL_QA_160120B
CREATE procedure [dbo].[spARG_EDI301_NotSend](
 @DtStart date
,@DtEnd date
)
AS
BEGIN
--SET @DtStart='2020-11-01'
--SET @DtEnd='2020-12-14'

select distinct 
HOU.Dt_Emis_HEM			[FECHA CREACION]
,HOU.Num_Proc_HEM		[JOB]
,LLP.ATD_lem			[ATD]
,PE.Num_Pedido			[PEDIDO]
,CO.Campo_Dados			[304]
,TP.Dt_Conclusao		[FECHA BOOKIN]
,JOB.Nr_Reserva			[BOOKING]
,ARM.Nome_Armador		[CARRIER]
,ARM.SAP_Code			[SAP CODE CARRIER]
,PT.Apelido				[INLAND TRUKER]
,PO.Numero_PO_HEM		[SHIPPER NUMER]
,EDI.Dt_Envio			[FECHA ENVIO EDI]
from House_Exp_Mar HOU			with(nolock)
INNER JOIN LLP_Exp_Mar LLP		with(nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_Lem
LEFT JOIN Job_Exp_Mar JOB		with(nolock) on	HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
LEFT JOIN Pedido_ship PS		with(nolock) on HOU.Num_Proc_HEM = PS.Num_Proc
LEFT JOIN PEDIDO PE				with(nolock) on PS.cd_pedido = PE.Cd_pedido
left Join EDI301 EDI			with(nolock) on EDI.num_proc=PS.num_proc
LEFT Join Campo_ORdem CO		with(nolock) on CO.cd_pedido=PS.cd_pedido and id_campo=3 AND CO.Campo_Dados  like  '%304'
LEFT Join Tarefas_PRocessos TP	with(nolock) on TP.id_task=1 and ps.num_proc=tp.num_proc and TP.Dt_Conclusao is not null
LEFT Join Armador ARM			with(nolock) on ARM.cd_armador=LLP.Cd_Armador_Lem --and SAP_CODE is not null
LEFT Join Pessoa_LLP PL			with(nolock) on LLP.Cd_Transportadora = PL.Cd_Pes and PL.Cd_Vendor is not NULL
LEFT Join Pessoa PT				with(nolock) on PL.cd_Pes = PT.Cd_Pes
LEFT JOIN PO_HEM PO				with(nolock) on HOU.Num_Proc_HEM = PO.Num_Proc_HeM and PO.ID_DC = 8
where
	CONVERT( date, HOU.Dt_Emis_HEM, 103)>=@DtStart
	AND CONVERT( date, HOU.Dt_Emis_HEM, 103)<= @DtEnd
	--AND (PO.Data_PO_HEM is null or EDI.Dt_Envio is null )--or EDI.Dt_Envio <>null)
	and left(ps.num_proc,5)='EMCSR' 
Order by hou.dt_Emis_HEM desc

	END
GO

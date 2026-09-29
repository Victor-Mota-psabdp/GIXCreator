SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--spDemurrageControl_Carrega_Container_Sel
--select * from demurrage_atl_det
--[spDemurrage_ATL_Rel]'2018-01-01','2018-12-31'
CREATE Procedure [dbo].[spDemurrage_ATL_Rel]--'2018-01-01','2018-12-31'
	@DtInicial datetime,
	@DtFinal datetime

as

select 
	DEM.Processo+DEM.Fatura					[Fatura],
	DEM.Processo+'/'+HOU.Num_Proc_MIM		[Ref.Actual],
	'Demurrage'								[Tipo Servicio],
	Dt_Emis									[Data de Emissão],
	convert(datetime,Vencimento,104)		[Data Vencimento],
	Destin.Cd_Pais + Destin.SCAC			[Pto Destino],
	Orig.Cd_Pais + Orig.SCAC				[Pto Origem],
	DET.Container							[Container],
	DET.Tipo_Container						[Tipo],
	DEM.HBL									[B/L],
	ARM.Nome_Armador						[Armador2],
	(case WHEN DEM.cd_pes IS NULL THEN 
		DEM.Apelido 
	ELSE P.Nome_raz_soc eND)				[Cliente],
	DEM.CNPJ								[CNPJ],
	convert(datetime,DET.Dt_Devolucao,104)	[Eir In],
	DET.F_Time								[Dias Livres],
	T_Diaria								[Trf. 1º Per.],
	T_diaria2								[Trf. 2º Per.],
	T_diaria3								[Trf. 3º Per.],
	D_1periodo								[1º Per.],
	d_2periodo								[2º Per.],
	d_3periodo								[3º Per.],
	
	DET.D_Cobrados							[Dias Demurrage],
	DEM.Valor								[Valor a Cobrar $],
	CXA.Vlr_Pgto_Rcto_HIA					[Valor Recibido $],
	DEM.Paridade							[Cambio Dolar],
	DEM.Valor * DEM.Paridade				[Valor Recibido R$],
	CXA.Dt_Pgto_Rcto_HIA					[Data Pagamento],
	DEM.Desconto							[Desconto],
	(CASE WHEN CXA.Vlr_Pgto_Rcto_HIA IS NULL THEN DEM.Valor 
		ELSE 0 END)							[Valor Pendente USD],
	(CASE WHEN CXA.Vlr_Pgto_Rcto_HIA IS NULL THEN 'Pendente' 
		ELSE 'Paga' END)					[Status],
	convert(datetime,dt_devolucao,105)		[inicio dias libres],
	D_Cobrados								[Inicio cobrança],
	CXA.Dt_Pgto_Rcto_HIA					[Fin cobrança],
	(case when DEM.Tipo ='F' then 'Final'else 'Partial' end)[Factura Parcial],
	
	
	DEM.dt_alter							[Data da Alteração do Status],
	
	
	(CASE WHEN cxa.Num_Lcto IS Not null then 'Closed' 
		else
	(Case when F.FatCod IS null then 'Invoice Canceled'
		else
		T.Status_Descricao	
	END) END) [Status_Descricao],
	LLP.ATA_Lim [ATA],
	LLP.Num_Proc_Lim [JOB]
from Demurrage_ATL DEM with(nolock)
	join Demurrage_ATL_Det	DET with(nolock) on DET.Processo = DEM.Processo and DET.Fatura = DEM.Fatura
	join House_Imp_Mar		HOU with(nolock) on HOU.Num_Proc_HIM = DEM.PROCESSO
	Left Join Job_Imp_Mar 	JOB with(nolock) on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
	Left Join Armador		ARM with(nolock) on JOB.Cd_Armador = Arm.Cd_Armador
	left join pessoa		P	with(nolock) on p.Cd_Pes = DEM.cd_pes
	Left Join Localidade	Orig with(nolock) on Cd_Org_HIM = Orig.Cd_Local 
	Left Join Localidade	Destin with(nolock) on Cd_Dst_HIM = Destin.Cd_Local 
	left join Tipo_Status_Demurrage	T with(nolock) on T.ID_Status = DEM.ID_Status
	left join vwFaturasValidas F with(nolock) on F.Fatcod = DEM.processo + DEM.fatura
	Left Join vwCXAS		CXA with(nolock) on F.num_proc = CXA.num_proc_HIA and F.cd_tp_tx=CXA.cd_tp_tx and F.dc=cxa.DC_HIA
	join LLP_Imp_Mar		LLP with(nolock) on LLP.Num_Proc_LIM = DEM.PROCESSO
Where 
	DEM.Dt_Emis between @DtInicial and @DtFinal
order by  DEM.Dt_Emis




GO

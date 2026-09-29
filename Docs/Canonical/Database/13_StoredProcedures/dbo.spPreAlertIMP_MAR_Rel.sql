SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spPreAlertIMP_MAR_Rel]--'IMVPF201106014BR','Administrador'

(
@Processo	varchar(16),
@Usuario	varchar(50)
)
AS
	
Declare @Cd_Usuario varchar(10)

set @Cd_usuario = (Select cd_usuario from usuario where nome_usuario = @Usuario)

select
			dbo.fBusca_Docs_PO_Modal(@Processo,'1') Num_Ordem,
			ORIG.Nome_Local		Origem,
			DEST.Nome_Local		Destino,
			left(HOU.Num_Proc_HIM,2) Modal,
			SH.Nome_Raz_Soc		Shipper,
			CS.Nome_Raz_Soc		Consignee,
			HOU.HAWB_HIM		HAWB,
			HOU.MAWB_HIM		MAWB,
			HOU.Navio_HiM		Voo_Navio,
			Qtd_Tot_Vol_HIM		Volume,
			HOU.Peso_Bruto_HiM	Peso_Bruto,
			LLP.ETD_LIM			ETD,
			LLP.ETA_LIM			ETA,
			LLP.ATD_LIM			ATD,
			HOU.viagem_him		Viagem,
			dbo.fNCM(@Processo)	NCM,
			dbo.fBusca_Containers (@Processo) Containers,
			TC.Nome_Tp_Carga Tipo,
			PROD.Produto_Descr	Descr_Produto,
			HOU.Obs_Him			OBS,
			US.Cargo,
			US.Fone,
			US.email,
			Po.numero_po_him	cemercante
		from 
			House_Imp_Mar		HOU
			Join LLP_Imp_Mar      LLP on HOU.Num_Proc_HIM	=LLP.Num_Proc_LIM
			Left Join Pedido_Ship PS on HOU.Num_Proc_HIM	=PS.Num_Proc
			Left Join Localidade  ORIG on HOU.Cd_Org_HIM	=ORIG.Cd_Local
			Left Join Localidade  DEST on HOU.cd_dst_HIM	=DEST.Cd_Local
			Left Join Produto_Cliente PROD	on PS.Cd_Produto=PROD.Cd_Prod
			Left Join Pessoa SH	on HOU.cd_export_him = SH.cd_pes
			Left Join Pessoa CS	on HOU.cd_consig_him = CS.cd_pes
			Left Join Usuario US on @Cd_Usuario = US.Cd_Usuario
			Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
			left join po_him PO on Hou.num_proc_him = PO.num_proc_him and id_dc = 29
		Where
			HOU.Num_Proc_HIM = @Processo
		Group by
			ORIG.Nome_Local,
			DEST.Nome_Local,
			left(HOU.Num_Proc_HIM,2),
			SH.Nome_Raz_Soc,
			CS.Nome_Raz_Soc,
			HOU.HAWB_HIM,
			HOU.MAWB_HIM,
			HOU.Navio_Him,
			Qtd_Tot_Vol_HIM,
			HOU.Peso_Bruto_Him,
			LLP.ETD_LIM,
			LLP.ETA_LIM,
			LLP.ATD_LIM,
			HOU.viagem_him,
			PROD.Produto_Descr,
			TC.Nome_Tp_Carga,
			HOU.Obs_Him,
			US.Cargo,
			US.Fone,
			US.email,
			Po.numero_po_him





GO

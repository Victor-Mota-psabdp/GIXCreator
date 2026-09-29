SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[spPreAlertIMP_Rel] --'IAVPF20100200101','Administrador'

(
@Processo	varchar(16),
@Usuario	varchar(50)
)
AS
	
Declare @Cd_Usuario varchar(10)

set @Cd_usuario = (Select cd_usuario from usuario where nome_usuario = @Usuario)

IF LEFT(@Processo,2) = 'IA'
	BEGIN
		--AEREA--
		select
			dbo.fBusca_Docs_PO_Modal(@Processo,'1') Num_Ordem,
			ORIG.Nome_Local		Origem,
			DEST.Nome_Local		Destino,
			left(HOU.Num_Proc_HIA,2) Modal,
			SH.Nome_Raz_Soc		Shipper,
			CS.Nome_Raz_Soc		Consignee,
			HOU.HAWB_HIA		HAWB,
			HOU.MAWB_HIA		MAWB,
			HOU.Voo_Hia			Voo_Navio,
			HOU.Vol_Tot_hia		Volume,
			HOU.Peso_Bruto_Hia Peso_Bruto,
			LLP.ETD_LIA			ETD,
			LLP.ETA_LIA			ETA,
			LLP.ATD_LIA			ATD,
			dbo.fNCM(@Processo)	NCM,
			Descr.Descr			Descr_Produto,
			HOU.Obs_Hia				OBS,
			US.Cargo,
			US.Fone,
			US.email,
			HOU.Qtd_Tot_Vol_HIA,
			LLP.Peso_Cubado_LIA
		from 
			House_Imp_Aer		HOU
			Join LLP_Imp_Aer LLP	 on HOU.Num_Proc_HIA	=LLP.Num_Proc_LIA
			Left Join Pedido_Ship PS on HOU.Num_Proc_HIA	=PS.Num_Proc
--			Left Join Produto_Cliente PROD	on PS.Cd_Produto=PROD.Cd_Prod
			Left Join Nature_Goods Descr on HOU.Num_proc_hia = Descr.Num_Proc 
			Left Join Localidade ORIG on HOU.Cd_Org_HIA	=ORIG.Cd_Local
			Left Join Localidade DEST on HOU.cd_dst_HIA	=DEST.Cd_Local
			left Join Pessoa SH	on HOU.cd_export_hia = SH.cd_pes
			left Join Pessoa CS	on HOU.cd_consig_hia = CS.cd_pes
			left Join Usuario US on @Cd_Usuario = US.Cd_Usuario
		Where
			HOU.Num_Proc_HIA = @Processo
		Group by
			ORIG.Nome_Local,
			DEST.Nome_Local,
			left(HOU.Num_Proc_HIA,2),
			SH.Nome_Raz_Soc,
			CS.Nome_Raz_Soc,
			HOU.HAWB_HIA,
			HOU.MAWB_HIA,
			HOU.Voo_Hia,
			HOU.Vol_Tot_hia,
			HOU.Peso_Bruto_Hia,
			LLP.ETD_LIA,
			LLP.ETA_LIA,
			Descr.Descr,
			HOU.Obs_Hia,
			US.Cargo,
			US.Fone,
			US.email,
			HOU.Qtd_Tot_Vol_HIA,
			LLP.Peso_Cubado_LIA,
			LLP.ATD_LIa
	END 
ELSE
	BEGIN
		--MARITMA--
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
			dbo.fNCM(@Processo)	NCM,
			Descr.Descr			Descr_Produto,
			HOU.Obs_Him			OBS,
			US.Cargo,
			US.Fone,
			US.email,
			HOU.Qtd_Tot_Vol_HIM
		from 
			House_Imp_Mar		HOU
			Join LLP_Imp_Mar      LLP on HOU.Num_Proc_HIM	=LLP.Num_Proc_LIM
			Left Join Pedido_Ship PS on HOU.Num_Proc_HIM	=PS.Num_Proc
			Left Join Localidade  ORIG on HOU.Cd_Org_HIM	=ORIG.Cd_Local
			Left Join Localidade  DEST on HOU.cd_dst_HIM	=DEST.Cd_Local
--			Left Join Produto_Cliente PROD	on PS.Cd_Produto=PROD.Cd_Prod
			Left Join Nature_Goods Descr on HOU.Num_proc_him = Descr.Num_Proc
			Left Join Pessoa SH	on HOU.cd_export_him = SH.cd_pes
			Left Join Pessoa CS	on HOU.cd_consig_him = CS.cd_pes
			Left Join Usuario US on @Cd_Usuario = US.Cd_Usuario
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
			Descr.Descr,
			HOU.Obs_Him,
			US.Cargo,
			US.Fone,
			US.email,
			HOU.Qtd_Tot_Vol_HIM
	END





GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spPreAlertEXP_MAR_Rel]--'EMOXT201105005BR','Administrador'

(
@Processo	varchar(16),
@Usuario	varchar(50)
)
AS
	
Declare @Cd_Usuario varchar(10)

set @Cd_usuario = (Select cd_usuario from usuario where nome_usuario = @Usuario)
	
	select
			hou.num_proc_hem						[BDP REF.],
			dbo.fBusca_Docs_PO_Modal(@Processo,'1') [PO],
			CE.numero_po_hem						[CE Mercante],
			ORIG.Nome_Local							[Origin],
			DEST.Nome_Local							[Destination],
			left(HOU.Num_Proc_HEM,2)				[Modal],
			SH.Nome_Raz_Soc							[Shipper],
			CS.Nome_Raz_Soc							[Consignee],
			HOU.MAWB_HEM							[MBL],
			HOU.HAWB_HEM							[HBL],
			HOU.Navio_HEM							[Vessel],
			HOU.viagem_hem							[Viagem],
			LLP.ETD_LEM								[ETD],
			LLP.ATD_LEM								[ATD],
			LLP.ETA_LEM								[ETA],
			dbo.fBusca_Containers (@Processo)		[Containers],
			TC.Nome_Tp_Carga						[Tipo],
			Qtd_Tot_Vol_HEM							[Quantity],
			HOU.Peso_Bruto_HEM						[GrossWeight],
			dbo.fNCM(@Processo)						[NCM],
			HOU.Obs_Hem								[Notes],	
			PROD.Produto_Descr						[Descr_Produto],
			US.Cargo								[Cargo],
			US.Fone									[Fone],
			US.email								[Email]		
			
		from 
			House_Exp_Mar			HOU		
			Join LLP_Exp_Mar		LLP on HOU.Num_Proc_HEM	=LLP.Num_Proc_LEM		
			left join po_hem		CE	on Hou.num_proc_hem = CE.num_proc_hem and CE.id_dc = 29
			Left Join Tipo_Carga	TC	on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga			
			Left Join Localidade	ORIG on HOU.Cd_Org_HEM	=ORIG.Cd_Local
			Left Join Localidade	DEST on HOU.cd_dst_HEM	=DEST.Cd_Local		
			Left Join Usuario		US	on @Cd_Usuario = US.Cd_Usuario			
			Left Join Pedido_Ship	PS	on HOU.Num_Proc_HEM	=PS.Num_Proc
			Left Join Produto_Cliente PROD	on PS.Cd_Produto=PROD.Cd_Prod
			Left Join Pessoa		SH	on HOU.cd_export_hem = SH.cd_pes
			Left Join Pessoa		CS	on HOU.cd_consig_hem = CS.cd_pes		
			
		Where
			HOU.Num_Proc_HEM = @Processo

		
GO

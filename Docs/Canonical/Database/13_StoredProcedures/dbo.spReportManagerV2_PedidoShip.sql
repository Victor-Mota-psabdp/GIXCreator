SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu - 03/08/2020 - incluido o isnull(PO_GRP,'') no group by
--[spReportManagerV2_PedidoShip] 'EMCTV202112021BR','273246',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
CREATE Procedure [dbo].[spReportManagerV2_PedidoShip]
	@Num_Proc	Varchar(16),
	@Cd_Prod	Varchar(50),
	@Qty		float output,
	@NCM		varchar(12) output,
	@ReponsiblePO varchar(30) output,
	@BusinessName varchar(50) output,
	@ValueCenter varchar(50) output,
	@ProductDescription varchar(200) output,
	@NetWeightKG float output,
	@GrossWeightKG float output,
	@OrderType varchar(30) output ,
	@POGroup char(3) output,
	@BusinessGroup varchar(50) output
as

Declare @NCM_PROC varchar(500)


	If @Cd_Prod <> 'N/A'
		Begin
			Select 
			@Qty = SUM(ps.qty),
			@NCM = isnull(NCM,''),
			@ReponsiblePO = UC.Nome_usuario,
			@BusinessName = Business_Descr,
			@ValueCenter = Value_Center_Descr,
			@ProductDescription = left(Produto_Descr,200),
			@NetWeightKG = (case when isnull(Peso_UOM,'') = 'LB' then sum(peso_liquido_tot) * 0.4536 else	
			sum(peso_liquido_tot) end),
			@GrossWeightKG = (case when isnull(Peso_UOM,'') = 'LB' then	sum(peso_bruto_tot) * 0.4536 else
			sum(peso_bruto_tot)	end),
			@OrderType = (Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'I' then 'Third' else
			Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'E' then 'Indent' else
			Case when Cd_Tipo = '3' then 'Inter-company' else
			Case when Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End),
			@POGroup = isnull(PO_GRP,''),
			@BusinessGroup = isnull(business_group_descr,'')
			From
				Pedido_Ship PS With(nolock)
				Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote
				Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
				Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
				Left Join DE_PARA_PRODUTO DPC With(nolock) on PC.cd_Proc_Cliente=DPC.GMID and PC.cd_Cliente = DPC.Cd_Cliente
				Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo
				LEft Join Pessoa_LLP PP With(nolock) on pp.cd_pes=cd_seller
				LEft Join Pessoa_LLP CS With(nolock) on CS.cd_pes=CD_BUYER
			Where
				ps.num_proc= @Num_Proc and PC.cd_Proc_Cliente = @Cd_Prod
			Group by 
				PS.Num_Proc, cd_Proc_cliente, Produto_Descr, isnull(NCM,''),UC.Nome_usuario ,
				Value_Center_Descr ,Business_Descr,cd_tipo,isnull(PO_GRP,'')	,business_group_descr,
				ITO_Especialista,isnull(Peso_UOM,'') 
				option(hash join)
				print @NetWeightKG
				print @GrossWeightKG
				
		End
	Else
		Begin	
			If 	substring(@Num_Proc,1,1) = 'E'
				Begin
					select TOP 1 

						@Qty = 0,
						@NCM = NCM,
						@ReponsiblePO = NULL,
						@BusinessName = NULL,
						@ValueCenter = NULL,
						@ProductDescription = Descricao_NCM,
						@GrossWeightKG  = HOU.peso_bruto,
						@NetWeightKG = HOU.peso_liquido,
						@OrderType = 'Samples',
						@POGroup = NULL,
						@BusinessGroup = 'N/A'
					from proc_ncm P with(nolock)
					Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
					Join vwHouse_Exp hou with(nolock) on hou.num_proc=P.num_proc
					where
						P.num_proc=@Num_Proc					
				End
			else
				Begin
					select TOP 1 						
						@Qty = 0,
						@NCM = NCM,
						@ReponsiblePO = NULL,
						@BusinessName = NULL,
						@ValueCenter = NULL,
						@ProductDescription = Descricao_NCM,
						@GrossWeightKG = HOU.peso_bruto,
						@NetWeightKG = HOU.peso_liquido,
						@OrderType = 'Samples',
						@POGroup = NULL,
						@BusinessGroup = 'N/A' 
					from proc_ncm P with(nolock)
					Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
					Join vwHouse_Imp hou with(nolock) on hou.num_proc=P.num_proc
					where
						P.num_proc=@Num_Proc
				End
		End












GO

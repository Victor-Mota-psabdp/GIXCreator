SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure	[dbo].[spAPAYImport_Rel]-- 'IMrob20090806801'
 --'IMCSR20080100701' --'10-25-2007'
(
	@Processo varchar(16)
)
As		

Declare @NF varchar(10)
Set @NF=(select TOP 1 Isnull(RPS_NFE,num_nf_hia) From vwcta_cte with(nolock) Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia where num_proc_hia=@Processo  and cd_tp_tx='SRV' and dc_hia='C')

if LEFT(@Processo,2) <>'BO'
	BEGIN
		select top 1
			'1058637' Codigo,left(processo_pc,2)+left(right(processo_PC,9),7) Fatura,
			Num_CPF_CNPJ CNPJ, dbo.fBusca_Docs_PO_Modal(@Processo,1) Num_Pedido,FAT.Processo_PC processo,Nome_Usuario Especialista,max(Data_PC) Dt_Fatura,
			PD.num_pedido Pedido,PD.cd_pedido,cd_prod,Nota_Fiscal,SUM(VLR_TOTAL_ITEM) fob,num_po,cd_proc_cliente GMID,Emissao,
		processo_pc,him.peso_bruto_HIM peso_bruto, @NF NF,DP.business_group_descr Business

		from fatura_chb FAT with(nolock)
		Join Pessoa PP with(nolock) on PP.cd_pes=FAT.cd_pes_PC
		Join Pedido_Ship PS with(nolock) on PS.num_proc=processo_pc
		Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
		Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
		left Join De_Para_Produto DP with(nolock) on DP.GMID=PC.cd_proc_cliente
		left join Usuario_Cliente US with(nolock) on US.cd_usuario=cd_CSRID
		LEFT Join Nota_cliente NC with(nolock) on NC.num_proc=Processo_PC
		left join House_Imp_Mar HIM with(nolock) on HIM.num_proc_him =Processo_PC
		left join nota_fiscal_cliente_det NCD with(nolock) on NC.ID_NF=NCD.ID_NF and NC.cd_cliente=NCD.cd_cliente and NCD.Cd_Produto=PS.cd_produto

		where
			processo_pc=@processo

		Group by 

			left(processo_pc,2)+left(right(processo_PC,9),7) ,Num_CPF_CNPJ ,Num_Pedido,FAT.Processo_PC ,Nome_Usuario,
			PD.num_pedido,PD.cd_pedido,cd_prod,Nota_Fiscal,num_po,num_pedido,GMID,emissao,processo_pc,him.peso_bruto_HIM,cd_proc_cliente,
			DP.business_group_descr	
	END
ELSE IF LEFT(@Processo,2) ='BO' AND @NF IS NOT NULL 
	BEGIN
		select top 1
			'1058637' Codigo,
			left(FAT.Processo_PC,2)+left(right(FAT.Processo_PC,9),7) Fatura,
			Num_CPF_CNPJ CNPJ, 
			dbo.fBusca_Docs_PO_Modal(FAT.Processo_PC,1) Num_Pedido,
			FAT.Processo_PC processo,		
			max(Data_PC) Dt_Fatura,
			@NF NF
		
	from fatura_chb FAT with(nolock)
		Join Pessoa PP with(nolock) on PP.cd_pes=FAT.cd_pes_PC
		LEFT JOIN JOB_HBO J with(nolock) on J.Num_Proc = FAT.Processo_PC	
	where
		FAT.PROCESSO_PC=@Processo

	Group by 
		FAT.PROCESSO_PC,Num_CPF_CNPJ,	
		J.Num_Proc_HBO
	END
else
	BEGIN
		select top 1
			'1058637' Codigo,
			left(J.Num_Proc_HBO,2)+left(right(J.Num_Proc_HBO,9),7) Fatura,
			Num_CPF_CNPJ CNPJ, 
			dbo.fBusca_Docs_PO_Modal(J.Num_Proc_HBO,1) Num_Pedido,
			J.Num_Proc_HBO processo,		
			max(Data_PC) Dt_Fatura,
			@NF NF
		
	from fatura_chb FAT with(nolock)
		Join Pessoa PP with(nolock) on PP.cd_pes=FAT.cd_pes_PC
		join JOB_HBO J with(nolock) on J.Num_Proc = FAT.Processo_PC	
	where
		J.Num_Proc_HBO=@Processo

	Group by 
		J.Num_Proc,Num_CPF_CNPJ,	
		J.Num_Proc_HBO
	END

GO

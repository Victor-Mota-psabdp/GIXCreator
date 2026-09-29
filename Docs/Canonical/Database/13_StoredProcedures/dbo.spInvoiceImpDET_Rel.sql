SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE     Procedure [dbo].[spInvoiceImpDET_Rel] --'2424'

	@ID_Inv	int
AS

select
	ProD.cd_Proc_Cliente GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	PROD.Produto_Descr P_Descricao,
	PROD.Produto_Descr S_Descricao,
	INV_DET.Quantidade,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	HOU.Vlr_Frete_Efet_HIA,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	HOU.Tp_Frete_HIA Tipo_Frete,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	PROD.NCM_Cliente NCM,
	Inv_CLI.Customer_Bank,
	HOU.cd_tp_oper Incoterm
from
	Invoice_Det INV_DET
	Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente		PROD		on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join House_IMP_Aer			HOU			on HOU.Num_Proc_HIA	=INV_CLI.Num_Proc
	Left Join volume_IMP_aer	VOL			on VOL.Num_Proc_HIA	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_IA)
	Left Join Tipo_Embalagem	VE			on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
Where
	 INV_DET.ID_Inv= @ID_Inv and INV_DET.Incluso='S'

UNION

select
	ProD.cd_Proc_Cliente GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	PROD.Produto_Descr P_Descricao,
	PROD.Produto_Descr S_Descricao,
	INV_DET.Quantidade,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	HOU.Vlr_Frete_Efet_HIM,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	HOU.Tp_Frete_HIM Tipo_Frete,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	PROD.NCM_Cliente NCM,
	Inv_CLI.Customer_Bank,
	HOU.cd_tp_oper Incoterm
from
	Invoice_Det INV_DET
	Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente		PROD		on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join House_IMP_MAR			HOU			on HOU.Num_Proc_HIM	=INV_CLI.Num_Proc
	Left Join volume_IMP_MAR	VOL			on VOL.Num_Proc_HIM	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_IM)
	Left Join Tipo_Embalagem	VE			on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
Where
	 INV_DET.ID_Inv= @ID_Inv and INV_DET.Incluso='S'


UNION

select
	ProD.cd_Proc_Cliente GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	PROD.Produto_Descr P_Descricao,
	PROD.Produto_Descr S_Descricao,
	INV_DET.Quantidade,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	HOU.Vlr_Frete_Efet_HIO,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	HOU.Tp_Frete_HIO Tipo_Frete,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	PROD.NCM_Cliente NCM,
	Inv_CLI.Customer_Bank,
	HOU.cd_tp_oper Incoterm
from
	Invoice_Det INV_DET
	Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente		PROD		on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join House_IMP_OUT			HOU			on HOU.Num_Proc_HIO	=INV_CLI.Num_Proc
	Left Join volume_IMP_OUT	VOL			on VOL.Num_Proc_HIO	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_IO)
	Left Join Tipo_Embalagem	VE			on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
Where
	 INV_DET.ID_Inv= @ID_Inv and INV_DET.Incluso='S'


















GO

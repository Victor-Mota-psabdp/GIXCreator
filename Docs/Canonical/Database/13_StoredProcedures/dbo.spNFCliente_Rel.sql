SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      Procedure [dbo].[spNFCliente_Rel] 
		@NUM_PROC	VARCHAR(16),
		@nota_Fiscal	Varchar(20)
as



IF LEFT(@NUM_PROC,1)='I'
  BEGIN
	select isnull(CFOP,'3101') CFOP_New, * from nota_cliente NC with(nolock)
	Join nota_fiscal_cliente_det NCD with(nolock) ON NCD.ID_NF=NC.ID_NF and NC.Cd_Cliente=NCD.Cd_Cliente
	Join Pessoa PP with(nolock) on PP.cd_pes=NC.cd_cliente
	where NUM_PROC=@NUM_PROC 
	--and nota_fiscal=@nota_fiscal 
	and right('0000000000' + Nota_fiscal,10) = right('0000000000' + @nota_fiscal,10) 
END
IF LEFT(@NUM_PROC,2)='EA'
  BEGIN
	Select hou.num_proc_hea num_proc, PO.numero_PO_HEA Nota_Fiscal, PO.data_po_hea EMISSAO,RE.Numero_PO_HEA RE_Number, re.data_po_hea Data_RE,RE.NUMERO_PO_HEA, right(NUM_CPF_CNPJ,len(num_cpf_cnpj)-1) CNPJ from house_exp_aer HOU with(nolock)
	Join PO_HEA PO with(nolock) on PO.num_proc_hea=HOU.num_proc_hea and PO.ID_DC=10
	Join PO_HEA RE with(nolock) ON RE.num_proc_hea=HOU.num_proc_hea and RE.id_DC=4
  	jOIN pESSOA pp with(nolock) ON PP.CD_PES=HOU.CD_EXPORT_HEA
	JOIN LLP_EXP_AER  LLP with(nolock) ON LLP.NUM_PROC_LEA=HOU.NUM_PROC_HEA
	WHERE HOU.NUM_PROC_HEA=@NUM_PROC
  END

IF LEFT(@NUM_PROC,2)='EM'
  BEGIN
	Select hou.num_proc_hem num_proc, PO.numero_PO_hem Nota_Fiscal, PO.data_po_hem EMISSAO,RE.Numero_PO_hem RE_Number, re.data_po_hem Data_RE,RE.NUMERO_PO_hem, right(NUM_CPF_CNPJ,len(num_cpf_cnpj)-1) CNPJ from house_exp_mar HOU with(nolock)
	Join PO_hem PO with(nolock) on PO.num_proc_hem=HOU.num_proc_hem and PO.ID_DC=10
	Join PO_hem RE with(nolock) ON RE.num_proc_hem=HOU.num_proc_hem and RE.id_DC=4
  	jOIN pESSOA pp with(nolock) ON PP.CD_PES=HOU.CD_EXPORT_hem
	JOIN LLP_EXP_mar LLP with(nolock) ON LLP.NUM_PROC_lem=HOU.NUM_PROC_hem
	WHERE HOU.NUM_PROC_hem=@NUM_PROC
  END
IF LEFT(@NUM_PROC,2)='EO'
  BEGIN
	Select hou.num_proc_heo num_proc, PO.numero_PO_heo Nota_Fiscal, PO.data_po_heo EMISSAO,RE.Numero_PO_heo RE_Number, re.data_po_heo Data_RE,RE.NUMERO_PO_heo, right(NUM_CPF_CNPJ,len(num_cpf_cnpj)-1) CNPJ from house_exp_out HOU with(nolock)
	Join PO_heo PO with(nolock) on PO.num_proc_heo=HOU.num_proc_heo and PO.ID_DC=10
	Join PO_heo RE with(nolock) ON RE.num_proc_heo=HOU.num_proc_heo and RE.id_DC=4
  	jOIN pESSOA pp with(nolock) ON PP.CD_PES=HOU.CD_EXPORT_heo
	JOIN LLP_EXP_out LLP with(nolock) ON LLP.NUM_PROC_leo=HOU.NUM_PROC_heo
	WHERE HOU.NUM_PROC_heo=@NUM_PROC
  END







GO

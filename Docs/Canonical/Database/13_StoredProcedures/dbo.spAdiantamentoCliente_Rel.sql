SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--spAdiantamentoCliente_Rel 'I','06855'

CREATE	PROCEDURE [dbo].[spAdiantamentoCliente_Rel]
	@Modal varchar(20),
	@POC 	varchar(15)
AS

IF left(@Modal,1) = 'E'
	Begin
		SELECT
			AC.ID,
			AC.Dt_Solicitacao,
			AC.Num_Proc, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,1) Ref_Cliente, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,1) PO, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,9) Customer_PO, 
			isnull(CIA.Apelido,CIAM.Apelido) Apelido,
			isnull(CIA.Num_CPF_CNPJ,CIAM.Num_CPF_CNPJ) Num_CPF_CNPJ,
			isnull(LMA.ETA_MAster,isnull(LEA.ETA_LEA,isnull(LEM.ETA_LEM,LEO.ETA_LEO))) ETA,
			isnull(L.Nome_Local,LM.Nome_Local) Nome_Local,
			(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where poc = '06855') and conta = 'C') TotalContaCliente,
			(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where poc = '06855') and conta = 'B') TotalContaBDP
		FROM
			Adiantamento_Cliente AC
			Left Join LLP_Exp_Aer LEA on LEA.Num_Proc_LEA=AC.Num_Proc
			Left Join LLP_Exp_Mar LEM on LEM.Num_Proc_LEM=AC.Num_Proc
			Left Join LLP_Exp_Out LEO on LEO.Num_Proc_LEO=AC.Num_Proc
			Left Join House_Exp_Aer HEA on HEA.Num_Proc_HEA=AC.Num_Proc
			Left Join House_Exp_Mar HEM on HEM.Num_Proc_HEM=AC.Num_Proc
			Left Join House_Exp_Out HEO on HEO.Num_Proc_HEO=AC.Num_Proc
			Left Join Pessoa CIA on CIA.cd_pes=isnull(HEA.Cd_Export_HEA,isnull(HEM.Cd_Export_HEM,HEO.Cd_Export_HEO))
			Left Join Localidade L on L.cd_local=isnull(HEA.Cd_Org_HEA,isnull(HEM.Cd_Org_HEM,HEO.Cd_Org_HEO))
			Left Join LLP_Master  LMA on LMA.Num_Proc_Master=AC.Num_Proc
			Left Join Master_Exp_Aer MEA on MEA.Num_Proc_MEA=AC.Num_Proc
			Left Join Master_Exp_Mar MEM on MEM.Num_Proc_MEM=AC.Num_Proc
			Left Join Pessoa CIAM on CIAM.cd_pes=isnull(MEA.Cd_Export_MEA,MEM.Cd_Export_MEM)
			Left Join Localidade LM on LM.cd_local=isnull(MEA.Cd_Org_MEA,MEM.Cd_Org_MEM)
		WHERE 
			AC.POC = @POC and (CIA.Nome_Raz_Soc is not null or CIAM.Nome_Raz_Soc is not null)
		ORDER BY
			AC.Dt_Solicitacao
	End
ELSE
	Begin
		SELECT
			AC.ID,
			AC.Dt_Solicitacao,
			AC.Num_Proc, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,1) Ref_Cliente, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,1) PO, 
			dbo.fBusca_Docs_PO_Modal(AC.Num_Proc,9) Customer_PO, 
			isnull(CIA.Apelido,CIAM.Apelido) Apelido,
			isnull(CIA.Num_CPF_CNPJ,CIAM.Num_CPF_CNPJ) Num_CPF_CNPJ,
			isnull(LMA.ETA_MAster,isnull(LIA.ETA_LIA,isnull(LIM.ETA_LIM,LIO.ETA_LIO))) ETA,
			isnull(L.Nome_Local,LM.Nome_Local) Nome_Local,
			(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where poc = '06855') and conta = 'C') TotalContaCliente,
			(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where poc = '06855') and conta = 'B') TotalContaBDP
		FROM
			Adiantamento_Cliente AC
			Left Join LLP_Imp_Aer LIA on LIA.Num_Proc_LIA=AC.Num_Proc
			Left Join LLP_Imp_Mar LIM on LIM.Num_Proc_LIM=AC.Num_Proc
			Left Join LLP_Imp_Out LIO on LIO.Num_Proc_LIO=AC.Num_Proc
			Left Join House_Imp_Aer HIA on HIA.Num_Proc_HIA=AC.Num_Proc
			Left Join House_Imp_Mar HIM on HIM.Num_Proc_HIM=AC.Num_Proc
			Left Join House_Imp_Out HIO on HIO.Num_Proc_HIO=AC.Num_Proc
			Left Join Pessoa CIA on CIA.cd_pes=isnull(HIA.Cd_Consig_HIA,isnull(HIM.Cd_Consig_HIM,HIO.Cd_Consig_HIO))
			Left Join Localidade L on L.cd_local=isnull(HIA.Cd_Dst_HIA,isnull(HIM.Cd_Dst_HIM,HIO.Cd_Dst_HIO))
			Left Join LLP_Master  LMA on LMA.Num_Proc_Master=AC.Num_Proc
			Left Join Master_Imp_Aer MIA on MIA.Num_Proc_MIA=AC.Num_Proc
			Left Join Master_Imp_Mar MIM on MIM.Num_Proc_MIM=AC.Num_Proc
			Left Join Pessoa CIAM on CIAM.cd_pes=isnull(MIA.Cd_Consig_MIA,MIM.Cd_Consig_MIM)
			Left Join Localidade LM on LM.cd_local=isnull(MIA.Cd_Dst_MIA,MIM.Cd_Dst_MIM)
		WHERE 
			AC.POC = @POC and (CIA.Nome_Raz_Soc is not null or CIAM.Nome_Raz_Soc is not null)
		ORDER BY
			AC.Dt_Solicitacao
	End








GO

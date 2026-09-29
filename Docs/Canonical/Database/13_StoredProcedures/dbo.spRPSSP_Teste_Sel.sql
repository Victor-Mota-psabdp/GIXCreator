SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRPSSP_Teste_Sel]
as
 select 
	BNF.Nota_Fiscal,
	BNF.cd_Status, 
	BNF.Emissao, 
	BNF.Valor_Total,
	BNF.CdsId,
	TM.cd_tp_pes,
	isnull(TM.Num_CPF_CNPJ,'')Num_CPF_CNPJ,
	isnull(TM.Num_RG_IE,'')NUM_RG_IE ,
	isnull(TM.Num_Insc_Munic,'')NUM_INSC_MUNIC,
	TM.Nome_Raz_Soc, 
	isnull(ENDE.Rua,'') Rua,
	isnull(ENDE.Numero,'') Numero, 
	isnull(ENDE.Compl_End,'') Compl_End,
	isnull(ENDE.Bairro,'') Bairro, 
	isnull(ENDE.Cidade,'') Cidade,
	isnull(ENDE.UF,'') UF,
	--isnull(ENDE.CEP,'') CEP,
	
	right('00000000' + replace(replace(isnull(ENDE.CEP,'00000000'),'.',''),'-',''),8) CEP,
	
	isnull(COM.Compl_Fone,'') Compl_Fone,
	--isnull(BNF.Observ_NF,'') Observ_NF,
	isnull([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(Observ_NF))),'') Observ_NF,
	isnull(ENDE.PAIS,'')	Pais
from 
	base_nota_fiscal BNF
	left outer join Pessoa TM on BNF.cd_pes = TM.cd_pes
    left outer join endereco ENDE on BNF.cd_pes = ENDE.cd_pes and Cd_tp_end = 'COM'
    left outer join comunicacao COM on BNF.cd_pes = COM.cd_pes and COM.cd_tp_com = 'TC1'
    where 
    
	ref_acesso = 'A' 
	--and rps_data is null 
	and emissao > '2010-01-01' and cd_Status <> 2
	and BNF.Nota_Fiscal = '74699'
    order by nota_fiscal





GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE pReservPca_Sel
(
@Num_Proc		VarChar(16)
)
 AS
Select 
	Cliente.Apelido as Cliente, ComCli.Contato as Cont_Cli, 
	EndCli.Rua as Rua_Cli, EndCli.Numero as Numero_Cli, 
	EndCli.Compl_End as Compl_Cli, EndCli.Bairro as Bairro_Cli,
	EndCli.Cidade as Cidade_Cli, ComCli.Prefixo as Pref_Cli, 
	ComCli.Num_Fone as Fone_Cli, ComCli.Cd_Area_Fone DDD_Cli,


	Dcto.Apelido as Pessoa_Dcto, ComDcto.Contato as Cont_Dcto, 
	EndDcto.Rua as Rua_Dcto, EndDcto.Numero as Numero_Dcto, 
	EndDcto.Compl_End as Compl_Dcto, EndDcto.Bairro as Bairro_Dcto,
	EndDcto.Cidade as Cidade_Dcto, ComDcto.Prefixo as Pref_Dcto, 
	ComDcto.Num_Fone as Fone_Dcto,ComDcto.Cd_Area_Fone DDD_Dcto,

	Crg.Apelido as Pessoa_Crg, ComCrg.Contato as Cont_Crg,  
	EndCrg.Rua as Rua_Crg, EndCrg.Numero as Numero_Crg, 
	EndCrg.Compl_End as Compl_Crg, EndCrg.Bairro as Bairro_Crg,
	EndCrg.Cidade as Cidade_Crg, ComCrg.Prefixo as Pref_Crg, 
	ComCrg.Num_Fone as Fone_Crg,ComCrg.Cd_Area_Fone DDD_Crg,
	JEM.*
From 
	House_Exp_Mar as HEM Join Job_exp_mar as JEM on JEM.Num_Proc_HEM = HEM.Num_Proc_HEM
	Join Pessoa as Cliente on Cliente.Cd_Pes = HEM.Cd_Export_HEM  
	Left Outer Join Comunicacao as ComCli on (ComCli.Cd_Pes = Cliente.Cd_Pes and ComCli.Cd_Tp_Com = JEM.Cd_Tp_Com_Cli) 
	Left Outer Join Endereco as EndCli on (EndCli.Cd_Pes = HEM.Cd_Export_HEM and EndCli.Cd_Tp_End = 'COM')
	
	Left Outer Join Pessoa as Dcto on Dcto.Cd_Pes = JEM.Cd_Pes_Dcto
	Left Outer Join Comunicacao as ComDcto on (ComDcto.Cd_Pes = Dcto.Cd_Pes and ComDcto.Cd_Tp_Com = JEM.Cd_Tp_Com_Dcto)
	Left Outer Join Endereco as EndDcto on (EndDcto.Cd_Pes = JEM.Cd_Pes_Dcto and EndDcto.Cd_Tp_End = 'COM')

	Left Outer Join Pessoa as Crg on Crg.Cd_Pes = JEM.Cd_Pes_Crg
	Left Outer Join Comunicacao as ComCrg on (ComCrg.Cd_Pes = Crg.Cd_Pes and ComCrg.Cd_Tp_Com = JEM.Cd_Tp_Com_Crg)
	Left Outer Join Endereco as EndCrg on (EndCrg.Cd_Pes = JEM.Cd_Pes_Crg and EndCrg.Cd_Tp_End = 'COM')
Where
	HEM.Num_PRoc_HEM = @Num_Proc


GO

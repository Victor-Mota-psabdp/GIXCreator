SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure [dbo].[spINTSmartBuscaTransportadora_Sel]
		@num_Proc Varchar(16)

AS

select nome_raz_soc,isnull(cd_vendor,'') Cd_Vendor from llp_imp_mar with(nolock)
Join Pessoa PP with(nolock) on pp.cd_pes=cd_transportadora
Join PEssoa_LLP PPL with(nolock) on PPL.cd_pes=cd_transportadora
where num_proc_lim=@num_Proc


union all

select nome_raz_soc,isnull(cd_vendor,'') Cd_Vendor from llp_imp_aer with(nolock)
Join Pessoa PP with(nolock) on pp.cd_pes=cd_transportadora
Join PEssoa_LLP PPL with(nolock) on PPL.cd_pes=cd_transportadora
where num_proc_lia=@num_Proc


GO

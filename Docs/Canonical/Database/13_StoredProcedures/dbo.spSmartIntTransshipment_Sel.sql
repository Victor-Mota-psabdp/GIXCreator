SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spSmartIntTransshipment_Sel
		@Num_Proc	Varchar(16)

AS



select 
	isnull(SCAC,cd_Local) SCAC,cd_Pais,upper(Nome_Local) Local 
from campo_processo With(Nolock)
	Join Localidade L with(nolock) on  L.cd_local= campo_Dados  COLLATE Latin1_General_CI_AI
where 
	id_Campo=44 and num_proc=@Num_PRoc
	and cd_pais is not null
GO

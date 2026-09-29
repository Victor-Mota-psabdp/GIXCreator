SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartTranshipmentName_Sel]
		@Num_Proc	varchar(16)
		
as


select Nome_Local, isnull(cd_pais,'')+Isnull(SCAC,cd_local) UNCode from Campo_Processo C with(nolock)
Join Localidade T with(nolock) on  T.cd_local collate Latin1_General_CI_AI=C.campo_dados collate Latin1_General_CI_AI  
where id_campo=44 and num_proc=@num_Proc

GO

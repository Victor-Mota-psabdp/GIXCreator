SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pHistGeral_InsUpd 
(
@HSGProcesso		varchar(16), 
@HSGSeq		int=null, 
@Apelido 		VarChar(25), 
@Cd_Tp_Ocor		int, 
@HSDDescricao	varchar(2000), 
@HSGData		datetime, 
@HSGDataFU		datetime, 
@Cd_Usuario		varchar(6) , 
@HSGDataConf		datetime=null 
)
AS 
	Declare @Cd_Pes		varchar(10) 
	Set @Cd_Pes =  (Select Cd_Pes From Pessoa Where Apelido = @Apelido)

	If @HSGSeq = null 
		Begin 
			Set @HSGSeq = IsNull((Select Max(HSGSeq) From Hist_Geral Where HSGProcesso = @HSGProcesso),0) + 1
			Insert Into Hist_Geral (HSGProcesso, HSGSeq, Cd_Pes, Cd_Tp_Ocor, HSDDescricao, HSGData, HSGDataFU, Cd_Usuario, HSGDataConf )
				Values (@HSGProcesso, @HSGSeq, @Cd_Pes, @Cd_Tp_Ocor, @HSDDescricao, @HSGData, @HSGDataFU, @Cd_Usuario, @HSGDataConf )
		End 
	Else
		Begin 
			Update 
				Hist_Geral
			Set 
				Cd_Pes = @Cd_Pes, 
				Cd_Tp_Ocor = @Cd_Tp_Ocor, 
				HSDDescricao = @HSDDescricao, 
				HSGData = @HSGData, 
				HSGDataFU = @HSGDataFU, 
				Cd_Usuario = @Cd_Usuario,
				HSGDataConf = @HSGDataConf
			Where 
				HSGProcesso = @HSGProcesso and 
				HSGSeq = @HSGSeq
		End
GO

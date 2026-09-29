SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgHistGeralHN_InsUpd] ON [dbo].[Hist_Geral] 
FOR INSERT,Update
AS
	Declare		@HSGProcesso	Varchar(16)
--			@HSGSeq			Int,
--			@Cd_Pes			Varchar(10),
--			@Cd_Tp_Ocor		Varchar(4),
--			@HSDDescricao	Varchar(2000),
--			@HSGData		Datetime,
--			@HSGDataFU		Datetime,
--			@Cd_Usuario		Datetime,
--			@HSGDataConf	Datetime,
		Declare	@Disp_Cliente	Char(1)
--			@Cd_Origem		Char(1),
--			@ID_NC			Varchar(50)

	
	Select @Disp_Cliente = Disp_Cliente from inserted 
	Select @hsgprocesso=hsgprocesso from inserted
	--if @Disp_Cliente='S'
		Begin 
			delete hist_geral_ultimohistorico where hsgprocesso=@hsgprocesso
			insert hist_geral_ultimohistorico
			--select top 1 * from inserted
			select top 1 HSGProcesso,HSGSeq,Cd_Pes,Cd_Tp_Ocor,HSDDescricao,HSGData,HSGDataFU,Cd_Usuario,HSGDataConf,Disp_Cliente,Cd_Origem,ID_NC
 from hist_geral where Disp_Cliente = 'S' and HSGProcesso = @hsgprocesso
			order by HSGData desc
		End

	

--ALTER TRIGGER [dbo].[TrgHistGeralHN_InsUpd] ON [dbo].[Hist_Geral] 
--FOR INSERT,Update
--AS
--	Declare		@HSGProcesso	Varchar(16)
----			@HSGSeq			Int,
----			@Cd_Pes			Varchar(10),
----			@Cd_Tp_Ocor		Varchar(4),
----			@HSDDescricao	Varchar(2000),
----			@HSGData		Datetime,
----			@HSGDataFU		Datetime,
----			@Cd_Usuario		Datetime,
----			@HSGDataConf	Datetime,
--		Declare	@Disp_Cliente	Char(1)
----			@Cd_Origem		Char(1),
----			@ID_NC			Varchar(50)

	
--	Select @Disp_Cliente = Disp_Cliente from inserted 
--	Select @hsgprocesso=hsgprocesso from inserted
--	if @Disp_Cliente='S'
--		Begin 
--			delete hist_geral_ultimohistorico where hsgprocesso=@hsgprocesso
--			insert hist_geral_ultimohistorico
--			select top 1 * from inserted

--		End





GO
ALTER TABLE [dbo].[Hist_Geral] ENABLE TRIGGER [TrgHistGeralHN_InsUpd]
GO

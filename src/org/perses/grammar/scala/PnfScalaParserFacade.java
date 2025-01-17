/*
 * Copyright (C) 2018-2022 University of Waterloo.
 *
 * This file is part of Perses.
 *
 * Perses is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3, or (at your option) any later version.
 *
 * Perses is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Perses; see the file LICENSE.  If not see <http://www.gnu.org/licenses/>.
 */
package org.perses.grammar.scala;

import com.google.common.primitives.ImmutableIntArray;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.perses.antlr.ParseTreeWithParser;
import org.perses.grammar.AbstractDefaultParserFacade;

public final class PnfScalaParserFacade
    extends AbstractDefaultParserFacade<PnfScalaLexer, PnfScalaParser> {

  public PnfScalaParserFacade() {
    super(
        LanguageScala.INSTANCE,
        createCombinedAntlrGrammar("PnfScala.g4", PnfScalaParserFacade.class),
        PnfScalaLexer.class,
        PnfScalaParser.class,
        ImmutableIntArray.of(PnfScalaLexer.Id, PnfScalaLexer.BoundVarid, PnfScalaLexer.Varid));
  }

  @Override
  protected PnfScalaLexer createLexer(CharStream inputStream) {
    return new PnfScalaLexer(inputStream);
  }

  @Override
  protected PnfScalaParser createParser(CommonTokenStream tokens) {
    return new PnfScalaParser(tokens);
  }

  @Override
  protected ParseTree startParsing(PnfScalaParser parser) {
    return parser.compilationUnit();
  }

  public ParseTreeWithParser parseWithOrigScalaParser(Path file) throws IOException {
    try (BufferedReader reader = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
      return parseWithOrigScalaParser(reader, file.toString());
    }
  }

  public ParseTreeWithParser parseWithOrigScalaParser(String scalaProgram) throws IOException {
    try (BufferedReader reader = new BufferedReader(new StringReader(scalaProgram))) {
      return parseWithOrigScalaParser(reader, "<in-memory>");
    }
  }

  public ParseTreeWithParser parseWithOrigScalaParser(String goProgram, String fileName)
      throws IOException {
    try (BufferedReader reader = new BufferedReader(new StringReader(goProgram))) {
      return parseWithOrigScalaParser(reader, fileName);
    }
  }

  private static ParseTreeWithParser parseWithOrigScalaParser(
      BufferedReader reader, String fileName) throws IOException {
    return parseReader(
        fileName,
        reader,
        charStream -> new ScalaLexer(charStream),
        commonTokenStream -> new ScalaParser(commonTokenStream),
        ScalaParser::compilationUnit);
  }
}

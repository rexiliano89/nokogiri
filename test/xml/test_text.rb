# frozen_string_literal: true

require "helper"

module Nokogiri
  module XML
    class TestText < Nokogiri::TestCase
      def test_css_path
        doc  = Nokogiri.XML("<root> foo <a>something</a> bar bazz </root>")
        node = doc.root.children[2]
        assert_instance_of(Nokogiri::XML::Text, node)
        assert_equal(node, doc.at_css(node.css_path))
      end

      def test_inspect
        node = Text.new("hello world", Document.new)
        assert_equal("#<#{node.class.name}:#{format("0x%x", node.object_id)} #{node.text.inspect}>", node.inspect)
      end

      def test_new
        node = Text.new("hello world", Document.new)
        assert(node)
        assert_equal("hello world", node.content)
        assert_instance_of(Nokogiri::XML::Text, node)
      end

      def test_lots_of_text
        100.times { Text.new("hello world", Document.new) }
      end

      def test_new_without_document
        doc = Document.new
        node = Nokogiri::XML::Element.new("foo", doc)
        new_node = nil

        assert_output(nil, /Passing a Node as the second parameter to Text.new is deprecated/) do
          new_node = Text.new("hello world", node)
        end
        assert(new_node)
      end

      def test_content=
        node = Text.new("foo", Document.new)
        assert_equal("foo", node.content)
        node.content = "& <foo> &amp;"
        assert_equal("& <foo> &amp;", node.content)
        assert_equal("&amp; &lt;foo&gt; &amp;amp;", node.to_xml)
      end

      def test_add_child
        node = Text.new("foo", Document.new)
        exc = if Nokogiri.jruby?
          RuntimeError
        else
          ArgumentError
        end
        assert_raises(exc) do
          node.add_child(Text.new("bar", Document.new))
        end
        assert_raises(exc) do
          node << Text.new("bar", Document.new)
        end
      end

      def test_wrap
        xml = '<root><thing><div class="title">important thing</div></thing></root>'
        doc = Nokogiri::XML(xml)
        text = doc.at_css("div").children.first
        text.wrap("<wrapper/>")
        assert_equal("wrapper", text.parent.name)
        assert_equal("wrapper", doc.at_css("div").children.first.name)
      end
    end
  end
end
